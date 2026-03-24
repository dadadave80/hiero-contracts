// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.4.9 <0.9.0;
pragma experimental ABIEncoderV2;

import {IHRC755ScheduleFacade} from "hiero-contracts/schedule-service/IHRC755ScheduleFacade.sol";
import {IHRC1215ScheduleFacade} from "hiero-contracts/schedule-service/IHRC1215ScheduleFacade.sol";

interface IHRCScheduleFacade is IHRC755ScheduleFacade, IHRC1215ScheduleFacade {}
