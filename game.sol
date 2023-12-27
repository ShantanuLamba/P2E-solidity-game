// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

pragma solidity ^0.8.7;

contract Bet {
    IERC20 public token;

    uint16 public setterN = 0;
    uint256 public maxbet = 100 * 10**18;

    mapping(address => uint16) public LatestRes;

    address s_owner;

    constructor() {
        s_owner = msg.sender;
    }

    function SetToken(IERC20 _token) public {
        require(msg.sender == s_owner);
        require(setterN == 0);
        token = _token;
        setterN = 1;
    }

    function ChangeMaxBet(uint256 change_value) public {
        require(msg.sender == s_owner);
        maxbet = change_value;
    }

    function retrieveERC20Asset(address assetAddress) external {
        require(msg.sender == s_owner, "Only the creator can retrieve assets");

        IERC20 asset = IERC20(assetAddress);
        uint256 balance = asset.balanceOf(address(this));
        require(asset.transfer(s_owner, balance), "Transfer failed");
    }

    function _settleBet(uint256 _amount) public {
        require(_amount < maxbet, "too big");
        require((_amount / 10000) * 10000 == _amount, "too small");
        require(token.balanceOf(msg.sender) >= _amount, "user balance insufficient");
        require(token.balanceOf(address(this)) >= _amount * 6 , "vault balance not enough");
        require(token.transferFrom(msg.sender, address(this), _amount), "transfer failed");

        uint256 _amountWagered = _amount;

        uint256 randomNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 100;

        address _user = msg.sender ;

        if (randomNumber > 40 && randomNumber < 70) {
            //10 percent
            uint256 WinAmount = (_amountWagered / 100) * 10;
            token.transfer(_user, _amountWagered + WinAmount);
            LatestRes[_user] = 1;
        } else if (randomNumber > 69 && randomNumber < 80) {
            //60 percent
            uint256 WinAmount = (_amountWagered / 100) * 60;
            token.transfer(_user, _amountWagered + WinAmount);
            LatestRes[_user] = 2;
        } else if (randomNumber > 79 && randomNumber < 95) {
            //2x
            uint256 WinAmount = _amountWagered * 2;
            token.transfer(_user, WinAmount);
            LatestRes[_user] = 3;
        } else if (randomNumber > 94 && randomNumber < 98) {
            //3x
            uint256 WinAmount = _amountWagered * 3;
            token.transfer(_user, WinAmount);
            LatestRes[_user] = 4;
        } else if (randomNumber > 97) {
            //5x
            uint256 WinAmount = _amountWagered * 5;
            token.transfer(_user, WinAmount);
            LatestRes[_user] = 5;
        } else {
            LatestRes[_user] = 9;
        }

    }
}
