//
//  MakeData.swift
//  YourRoute
//
//  Created by Jeans on 12/6/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

struct MakeData {
    
    //MARK: - for draw Map Itinerarie
    
    static func makeItinerariePoints() -> Itinerarie {
        var testLegs = [Leg]()
        
        testLegs.append(
            Leg(startTime: 1575495226000.0, endTime: 1575495748000.0,
                mode: "WALK", duration: 40, distance: 428,
                from: Place(name: "Origin", lat: 60.184229958105, lon: 24.949350357055664, stop: nil),
                to: Place(name: "Wallininkatu", lat: 60.18556, lon: 24.94337, stop: nil),
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: Geometry(length: 23, points: "kvinJuzgwCB??b@@fACHTb@GTGR{B|HGRGRBDBDPZh@dAqB~GUv@ADiAH@\\@X?DFv@")) )
        
        testLegs.append(
            Leg(startTime: 1575495748000.0, endTime: 1575496034000.0,
                mode: "BUS", duration: 286, distance: 5430,
                from: Place(name: "Wallininkatu", lat: 60.18556, lon: 24.94337, stop: nil),
                to: Place(name: "Töölön kisahalli", lat: 60.184173, lon: 24.924404, stop: nil),
                route: Route(shortName: "65"),
                intermediateStops: [],
                type: nil,
                legGeometry: Geometry(length: 37, points: "__jnJ{vfwCOuAYDiE`Bc@b@pA|En@`Cf@bBj@jBh@nGjAnOH`Az@lKABf@nGFh@J`@P^DA|BbAEz@Gt@Gj@_A~DE\\A^?b@RvD^hJ@z@?t@It@Mf@Qb@U\\DN~@~C") ) )
        
        testLegs.append(
            Leg(startTime: 1575496034000.0, endTime: 1575496640000.0,
                mode: "WALK", duration: 606, distance: 1230,
                from: Place(name: Optional("Töölön kisahalli"), lat: 60.184173, lon: 24.924404, stop: nil),
                to: Place(name: Optional("Töölön kisahalli"), lat: 60.18433, lon: 24.92357, stop: nil),
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: Geometry(length: 5, points: "ovinJy`cwCFVPl@DJi@~@")) )
        
        testLegs.append(
            Leg(startTime: 1575498120000.0, endTime: 1575499800000.0,
                mode: "BUS", duration: 1680, distance: 12450,
                from: Place(name: "Töölön kisahalli", lat: 60.18433, lon: 24.92357, stop: nil),
                to: Place(name: "Espoon asema", lat: 60.20556, lon: 24.65573, stop: nil),
                route: Route(shortName: "134N"),
                intermediateStops: [],
                type: nil,
                legGeometry: Geometry(length: 425, points: "wvinJkzbwC}@~AiCnE]h@a@l@k@v@i@x@i@v@W^aCdDQVcChCw@x@c@b@mCxCSXkAjBy@zAkAbDwD`LYbAM^m@rBGX[pAqBfIK^yB|Io@bCkBvHqCjLm@~Bg@fBgAvAu@bAi@j@sEhAgCLeBRo@@SD}AJ[PaJnHaAj@YHoAL{B?gFLqDHm@@q@DuBFu@@cBAqDKaDSgAEKdISdGc@hGgA`Q_@fGObBMz@_@pA[p@_@b@}@z@yAjAkAdAwCvCq@l@i@n@sD`Ek@lAm@pAMc@_@i@SI[GU@[PQVEBM^Ol@Kt@En@@HBjAP|@N^PX`@XEx@DnC?`BCnBOpBMf@_CpOaCtLiAxFoAnFyFpTiAfEQd@yBrI_FbR}@hD}@tCWj@y@d@i@NW?[C[K_@U[OwBuAsAm@kCyAoAWMf@MfAK~@{A~Si@pH_@hFe@dGIrCK|CEx@IpG?^?~BDxAP|BVlBr@|B\\hAbApCjIrQlArCh@xAl@lBv@hDF\\Hj@Hp@J|@RjBZlDLzB@lADrBJzDHpFD|BHjF?PBxBFhBDfBFnALvBd@vEbAtJd@lEN`BL~CBjABvCEvDAvFCrAGrGCxHE`DOpLGzAYpFO`CIvDIjC?BExBMdG?rIB|BNtLH~E@rBAfAMnDa@bDYrAm@lBi@lAc@z@}DpGq@pAYl@q@fBo@lB_@~AUjAg@bDWnBMpAUlCQnCMpCGzBIrGCfF@zEFxHB`D@dDEzBGpBK`BIbAOtA]xBo@jEYnAk@xBkCbJmBcCm@s@UMs@a@g@Ow@Yo@Cm@Ai@Da@L]LWL[Rm@h@g@p@qBhCeAfBa@l@d@dCR`AZnBL|@F|@DnB?t@E~@GxAAXG|AKxDQzEInCQhEInCD`BBp@Df@RnBr@rE^xBj@fCvBzITzALbAHfAHnBF`BRxEF`BNdEPlEJrAH^fBsAxC{Db@i@l@q@\\[BzEDzDLbE^rLBvC@vCAhFClDa@~NO|EC`BGdCAnBAdELrIN|DFvAPrCPlETxF@ZB|@D~@@`AFjAZ|HV|GZhIXlG\\zIPrED`ADpACzEMxEQhGMxCAJGbBk@xPEnCErDHnCt@|Lp@dK^xFNhCJnCFdDClCE|CEb@KbHErCA`CNzGjAv\\R~FLfOXpb@Bx@BpALpDPdELzDJrCDr@pAx^H~D@bFBrD?|@J`CP|BR|B|@bEv@xDt@tD\\jBVvBHjCAvBKnBKh@QjA_AbDbE|M`@fA\\r@t@nA`@j@n@r@z@t@v@h@vBdAhB~@`@TnAz@~BfCb@j@BB|@vALTd@~@h@lA~@dCH\\Nb@d@`Bf@vBh@lCn@hEj@bDlAfG`AaAb@[j@c@fC_CnAaBfAkB^{@nAmCtDqKXs@v@aBb@s@^k@t@s@lA_ApA{@jA{@dCkBtC{B`BhN`BbNb@~D")) )
        
        testLegs.append(
            Leg(startTime: 1575499800000.0, endTime: 1575500314000.0,
                mode: "WALK", duration: 3750, distance: 300,
                from: Place(name: "Espoon asema", lat: 60.20556, lon: 24.65573, stop: nil),
                to: Place(name: "Destination", lat: 60.20556641456011, lon: 24.653427600860596, stop: nil),
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: Geometry(length: 14, points: "u{mnJyqnuCFZFl@D\\EF@N@LBD\\xCBR?F@J[`@m@b@")) )
        
        
        let testItinerarie = Itinerarie(walkDistance: 300, walkDuration: 900, duration: 120, legs: testLegs,
                                        originPlace: ResultPlace(name: "Kamppi, Helsinki - Start", latitude: 60.184229958105, longitude: 24.949350357055664),
                                        destinationPlace: ResultPlace(name: "Espoo, Espoo - End", latitude: 60.20556641456011, longitude: 24.653427600860596))
        //before: 60.20556, longitude: 24.65573
        return testItinerarie
    }
    
    
    //MARK: - for Route Detail ViewController
    
    static func makeItinerarieDetail() -> [Itinerarie] {
        var testLegs = [Leg]()
        
        testLegs.append(
            Leg(startTime: 1575495226000.0, endTime: 1575495748000.0,
                mode: "WALK", duration: 40, distance: 428,
                from: Place(name: "Origin", lat: 0, lon: 0, stop: nil),
                to: nil,
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575495748000.0, endTime: 1575496034000.0,
                mode: "BUS", duration: 286, distance: 5430,
                from: Place(name: "Haapaniemi", lat: 0, lon: 0,
                            stop: Stop(code: "2406", desc: "Hämeentie 16", platformCode: nil)),
                to: nil,
                route: Route(shortName: "65"),
                intermediateStops: [],
                type: nil,
                legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575496034000.0, endTime: 1575496640000.0,
                mode: "WALK", duration: 606, distance: 1230,
                from: Place(name: Optional("Rautatientori"), lat: 0, lon: 0,
                            stop: Stop(code: Optional("2139"), desc: Optional("Vilhonkatu"), platformCode: nil)),
                to: nil,
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575498120000.0, endTime: 1575499800000.0,
                mode: "BUS", duration: 1680, distance: 12450,
                from: Place(name: Optional("Kamppi"), lat: 0, lon: 0,
                            stop: Stop(code: Optional("1249"), desc: Optional("Kamppi"), platformCode: "49")),
                to: nil,
                route: Route(shortName: "134N"),
                intermediateStops:
                [Optional(YourRoute.Stop(code: Optional("1234"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("1011"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2205"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2037"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2016"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2151"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E2132"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3227"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3228"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3256"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3268"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3266"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3263"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3204"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3206"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3224"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E3209"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4934"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4325"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4327"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E4301"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6167"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6171"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6015"), desc: nil, platformCode: nil)), Optional(YourRoute.Stop(code: Optional("E6025"), desc: nil, platformCode: nil))],
                type: nil,
                legGeometry: nil) )
        
        testLegs.append(
            Leg(startTime: 1575499800000.0, endTime: 1575500314000.0,
                mode: "WALK", duration: 3750, distance: 300,
                from: Place(name: "Espoon asema", lat: 0, lon: 0,
                            stop: Stop(code: "E6024", desc: Optional("Siltakatu"), platformCode: "22")),
                to: nil,
                route: nil, intermediateStops: [],
                type: nil,
                legGeometry: nil) )
        
        
        var itineraries: [Itinerarie] = []
        
        var testItinerarie = Itinerarie(walkDistance: 300, walkDuration: 2300, duration: 120, legs: testLegs,
                                        originPlace: ResultPlace(name: "Kamppi, Helsinki - Start", latitude: 60.184229958105, longitude: 24.949350357055664),
                                        destinationPlace: ResultPlace(name: "Espoo, Espoo - End", latitude: 60.20556, longitude: 24.65573))
        itineraries.append(testItinerarie)
        
        testItinerarie.walkDistance = 2500
        testItinerarie.walkDuration = 1200
        testItinerarie.duration = 600
        itineraries.append(testItinerarie)
        
        testItinerarie.walkDistance = 4200
        testItinerarie.walkDuration = 5100
        testItinerarie.duration = 800
        itineraries.append(testItinerarie)
        
        return itineraries
    }
}
