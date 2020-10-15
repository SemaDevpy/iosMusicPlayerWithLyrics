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
    var songInfo = SongInfo()
    
    var arrayOfTitles = [String]()
    var arrayOfSingers = [String]()
    var indexCurrent = 0
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeLabel: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songManager.delegate = self
        label.text = "\(singer) - \(song)"
        songManager.fetchLyrics(artist : singer, title : song)
        
        lyricsTextView.layer.borderWidth = 1
        lyricsTextView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        
        for item in songInfo.songsArray{
            arrayOfTitles.append(item.title)
        }
        for item in songInfo.songsArray{
            arrayOfSingers.append(item.singer)
        }
    }
    
    //Play-Button
    @IBAction func playPressed(_ sender: UIButton) {
        if player?.isPlaying == true{
            playButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
            player?.stop()
        }else{
            playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playMusic(with: song)
        }
        
    }
    
    //Next-Button
    @IBAction func nextPressed(_ sender: UIButton) {
        indexCurrent = arrayOfTitles.firstIndex(of: song)!
        if indexCurrent != 9{
            song = arrayOfTitles[indexCurrent + 1]
            singer = arrayOfSingers[indexCurrent + 1]
        }else{
            song = arrayOfTitles[0]
            singer = arrayOfSingers[0]
        }
        
        
        songManager.fetchLyrics(artist : singer, title : song)
        
        
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.label.text = "\(self.singer) - \(self.song)"
            self.playMusic(with: self.song)
        }
        
        
    }
    
    
    
    //prev-button
    @IBAction func prevPressed(_ sender : UIButton){
        indexCurrent = arrayOfTitles.firstIndex(of: song)!
        
        if indexCurrent != 0{
            song = arrayOfTitles[indexCurrent - 1]
            singer = arrayOfSingers[indexCurrent - 1]
        }else{
            song = arrayOfTitles[9]
            singer = arrayOfSingers[9]
        }
        
        
        
        
        songManager.fetchLyrics(artist : singer, title : song)
        
        
        
        
        DispatchQueue.main.async {
            self.playButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.label.text = "\(self.singer) - \(self.song)"
            self.playMusic(with: self.song)
        }
    }
    
    //Volume-slider
    @IBAction func volumeSlider(_ sender: UISlider) {
        player?.volume = sender.value
    }
    
    
    //playing Music
    func playMusic(with song : String){
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
