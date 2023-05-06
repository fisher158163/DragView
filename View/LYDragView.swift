//  LYDragView.swift
//  CleanMyMac
//
//  Created by Fisher on 2023/5/6.

import Cocoa

protocol LYDragViewDelegate: NSObjectProtocol {
    // 回调用户拖拽文件的路径数组
    func dragFilePathList(_ filePathList: [String])
}

class LYDragView: NSView {
    
    weak var delegate: LYDragViewDelegate?
    
    // 拖动事件所监听的数据类型
    let filenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // MARK: 注册view拖动事件所监听的数据类型
        // let filenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
        registerForDraggedTypes([filenamesPboardType])
    }

    // drawRect
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    // MARK: 当文件拖入到view中
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard
        // 过滤掉非法的数据类型
        if pasteboard.types?.contains(filenamesPboardType) == true {
            return .copy
        } else {
            return []
        }
    }
    
    // MARK: 拖入文件后松开鼠标
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        // 从粘贴板中提取需要的NSFilenamesPboardType数据
        guard let filePathList = pasteboard.propertyList(forType: filenamesPboardType) as? [String] else {
            return false
        }
        // 将文件路径组通过代理回调出去
        delegate?.dragFilePathList(filePathList)
        return true
    }
}
