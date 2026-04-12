# ---------------------------------
# Implementation of the Comms stack
# ---------------------------------

# downlink

import Svc.Ccsds.SpacePacketFramer
import Svc.Ccsds.TmFramer

# uplink

import Svc.FrameAccumulator
import Svc.Ccsds.TcDeframer
import Components.Authenticate
import Svc.Ccsds.SpacePacketDeframer
import Components.AuthenticationRouter

# dependencies for current imports

import Svc.Interfaces.Framer
import Svc.Interfaces.Deframer.fpp"
import Fw.Com

# TODO : import buffers, connect to other layers, scheduling in AuthenticationRouter?

topology ScalarComms {

    # instances can be treated as objects of their class 
    # (i.e. you can point output of an instance of TcDeframer to Authenticate)

    instance spf : SpacePacketFramer
    instance tmf : TmFramer

    instance accum : FrameAccumulator
    instance tc : TcDeframer
    instance auth : Authenticate
    instance spd : SpacePacketDeframer
    instance router : AuthenticationRouter


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
        router.dataReturnOut -> spd.dataReturnIn

        # ----------------------------------------------------------------------------------------
        # status sending: downstream tells upstream if it's ready to receive
        # LoRa → TmFramer → SpacePacketFramer → ComQueue → TlmPacketizer (so maybe a cdh problem?)
        # ----------------------------------------------------------------------------------------

        tmf.comStatusOut -> spf.comStatusIn
        #here spf.comStatusOut would send status upstream
    }

}