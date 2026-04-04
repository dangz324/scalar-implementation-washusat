#
# Implementation of the Comms stack
#

# downlink

import "../../external/proves/lib/fprime/Svc/Ccsds/SpacePacketFramer/SpacePacketFramer.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/TmFramer/TmFramer.fpp"

# uplink

import "../../external/proves/lib/fprime/Svc/FrameAccumulator/FrameAccumulator.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/TcDeframer/TcDeframer.fpp"
import "../../external/proves/PROVESFlightControllerReference/Components/Authenticate/Authenticate.fpp"
import "../../external/proves/lib/fprime/Svc/Ccsds/SpacePacketDeframer/SpacePacketDeframer.fpp"
import "../../external/proves/PROVESFlightControllerReference/Components/AuthenticationRouter/AuthenticationRouter.fpp"

# dependencies for current imports

import "../../external/proves/lib/fprime/Svc/Interfaces/Framer.fpp"
import "../../external/proves/lib/fprime/Svc/Interfaces/Deframer.fpp"
import "../../external/proves/lib/fprime/Fw/Com/Com.fpp"

topology ScalarComms {

    # instances can be treated as objects of their class 
    # (i.e. you can point output of an instance of TcDeframer to Authenticate)

    instance spf : Svc.Ccsds.SpacePacketFramer
    instance tmf : Svc.Ccsds.TmFramer

    instance accum : Svc.FrameAccumulator
    instance tc : Svc.Ccsds.TcDeframer
    instance auth : Components.Authenticate
    instance spd : Svc.Ccsds.SpacePacketDeframer
    instance router : Components.AuthenticationRouter

    instance cmdDisp : Svc.CommandDispatcher
    instance tlmPkt  : Svc.TlmPacketizer
    instance comQ    : Svc.ComQueue

    connections {
        # ---------------------------------------
        # downlink: SpacePacketFramer -> TmFramer
        # ---------------------------------------

        spf.dataOut -> tmf.dataIn

        # buffers: f' essentially passes along a single buffer for each component to use,
        # so we need to return those buffers once we've passed the info along

        tmf.dataReturnOut -> spf.dataReturnIn
        # here spf.dataReturnOut would return to cdh
        
        # -----------------------------------------------------------------------------------------------------
        # uplink: FrameAccumulator -> TcDeframer -> Authenticate -> SpacePacketDeframer -> AuthenticationRouter
        # -----------------------------------------------------------------------------------------------------

        # transfer frame layer
        accum.dataOut -> tc.dataIn

        # security layer
        tc.dataOut -> auth.dataIn

        # space packet layer
        auth.dataOut -> spd.dataIn
        spd.dataOut -> router.dataIn

        # buffers

        # here accum.dataReturnOut would return to transport
        auth.dataReturnOut -> tc.dataReturnIn
        spd.dataReturnOut -> auth.dataReturnIn
        router.dataReturnOut -> spd.dataReturnin

        # ----------------------------------------------------------------------------------------
        # status sending: downstream tells upstream if it's ready to receive
        # LoRa → TmFramer → SpacePacketFramer → ComQueue → TlmPacketizer (so maybe a cdh problem?)
        # ----------------------------------------------------------------------------------------

        tmf.comStatusOut -> spf.comStatusIn
        #here spf.comStatusOut would send status upstream
    }

}