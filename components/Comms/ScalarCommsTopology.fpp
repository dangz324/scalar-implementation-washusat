/*
Implementation of the Comms stack
*/

//uplink

import "../../external/proves/lib/fprime/Svc/Ccsds/SpacePacketFramer/SpacePacketFramer.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/TmFramer/TmFramer.fpp"

//downlink

import "../../external/proves/lib/fprime/Svc/FrameAccumulator/FrameAccumulator.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/TcDeframer/TcDeframer.fpp"
import "../../external/proves/PROVESFlightControllerReference/Components/Authenticate/Authenticate.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/SpacePacketDeframer/SpacePacketDeframer.fpp"
import "../../external/proves/PROVESFlightControllerReference/Components/AuthenticationRouter/AuthenticationRouter.fpp"

import "../../external/proves/lib/fprime-zephyr/Drv/LoRa/LoRa.fpp"

topology ScalarComms {
    instance framer : SpacePacketFramer
    instance tm : TmFramer

    instance accumulator : FrameAccumulator
    instance tc : TcDeframer
    instance auth : Authenticate
    instance spd : SpacePacketDeframer
    instance router : AuthenticationRouter

    instance lora : LoRa


}