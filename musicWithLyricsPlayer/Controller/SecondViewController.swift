//
//  SecondViewController.swift
//  musicWithLyricsPlayer
//
//  Created by Syimyk on 10/14/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {

    var player : AVAudioPlayer?
    
    var singer : String = ""
    var song : String = ""

    var songManager = SongManager()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songManager.delegate = self
        label.text = "\(singer) - \(song)"
        songManager.fetchLyrics(artist : singer, title : song)
        lyricsTextView.layer.borderWidth = 1
        lyricsTextView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    }
    @IBAction func playPressed(_ sender: UIButton) {
        if player?.isPlaying == true{
            playButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
            player?.stop()
        }else{
            playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playMusic()
        }
        
    }
    
    func playMusic(){
        let soundURl = Bundle.main.url(forResource: "\(song)", withExtension: "mp3")
        do{
            try player =  AVAudioPlayer(contentsOf: soundURl!)
        }catch{
            print(error)
        }
        
        player?.play()
    }


}


//MARK: - SongManagerDelegate

extension SecondViewController : SongManagerDelegate{
    func didUpdateText(_SongManager: SongManager, song: SongModel) {
        DispatchQueue.main.async {
            self.lyricsTextView.text = song.lyrics
        }
    }
    
    func didFailWitherror(error: Error) {
        print(error)
    }
}
