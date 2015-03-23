//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Nicholas Busby on 3/22/15.
//  Copyright (c) 2015 Nicholas Busby. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    required init(filePathUrl: NSURL, title: String?){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}