import Cocoa
import Foundation

class MusicMonitor {
    let outputFile = "/tmp/music_info.txt"
    var lastInfo: [AnyHashable: Any] = [:]
    
    init() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(musicChanged),
            name: NSNotification.Name("com.apple.Music.playerInfo"),
            object: nil
        )
        
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(musicChanged),
            name: NSNotification.Name("com.apple.iTunes.playerInfo"),
            object: nil
        )
    }
    
    func fetchArtwork() -> Data? {
        let script = """
        tell application "Music"
            if player state is playing then
                return data of artwork 1 of current track
            end if
        end tell
        """
        
        var error: NSDictionary?
        
        guard let scriptObject = NSAppleScript(source: script) else {
            return nil
        }
        
        let output = scriptObject.executeAndReturnError(&error)
        
        if error != nil {
            return nil
        }
        
        return output.data
    }


    @objc func musicChanged(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        
        let title = info["Name"] as? String ?? ""
        let artist = info["Artist"] as? String ?? ""
        let album = info["Album"] as? String ?? ""
        let state = info["Player State"] as? String ?? ""
        
        if title != lastInfo["Name"] as? String {
            if let artworkData = fetchArtwork() {
                try? artworkData.write(to: URL(fileURLWithPath: "/tmp/album.jpg"))
            }
        }
        lastInfo = info

        let content = """
        title:\(title)
        artist:\(artist)
        album:\(album)
        state:\(state)
        timestamp:\(Date())
        """
        
        try? content.write(toFile: outputFile, atomically: true, encoding: .utf8)
    }
}

let monitor = MusicMonitor()
RunLoop.current.run()