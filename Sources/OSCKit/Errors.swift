//
//  Errors.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2021-01-29.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

public extension OSCMessage {
	
	enum DecodeError: Error {
		
		/// Malformed data. `verboseError` contains the specific reason.
		case malformed(_ verboseError: String)
		
		/// An unexpected OSC-value type was encountered in the data.
		/// `tagCharacter` contains the OSC Type Tag encountered.
		case unexpectedType(_ tagCharacter: Character)
		
	}
	
}


public extension OSCBundle {
	
	enum DecodeError: Error {
		
		/// Malformed data. `verboseError` contains the specific reason.
		case malformed(_ verboseError: String)
		
	}
	
}
