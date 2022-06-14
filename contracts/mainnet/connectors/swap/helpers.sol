//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import { InstaConnectors } from "../../common/interfaces.sol";

contract SwapHelpers {
	/**
	 * @dev Instadapp Connectors Registry
	 */
	InstaConnectors internal constant instaConnectors =
		InstaConnectors(0x97b0B3A8bDeFE8cB9563a3c610019Ad10DB8aD11);

	/**
	 *@dev Swap using the dex aggregators.
	 *@param _connectors name of the connectors in preference order.
	 *@param _data data for the swap cast.
	 */
	function _swap(string[] memory _connectors, bytes[] memory _data)
		internal
		returns (bool success, bytes memory returnData)
	{
		uint256 _length = _connectors.length;
		require(_length > 0, "zero-length-not-allowed");
		require(_data.length == _length, "calldata-length-invalid");

		for (uint256 i = 0; i < _length; i++) {
			(success, returnData) = instaConnectors
				.connectors(_connectors[i])
				.delegatecall(_data[i]);
			if (success) {
				break;
			}
		}
	}
}
