//
//  SmallBoardController.swift
//  Robots
//
//  Created by Pete Bennett on 09/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class SmallBoardController: BoardController {
    override     func getNewBoard() -> Board {
        mBoard = Board(controller: self, width:  3, height: 1)
        return mBoard!
    }
}
