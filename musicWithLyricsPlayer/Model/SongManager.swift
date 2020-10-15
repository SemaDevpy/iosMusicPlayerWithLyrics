//
//  SongManager.swift
//  musicWithLyricsPlayer
//
//  Created by Syimyk on 10/14/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import Foundation

protocol SongManagerDelegate {
    func didUpdateText(_SongManager : SongManager,song : SongModel)
    func didFailWitherror(error : Error)
}


struct SongManager {
    
    var delegate : SongManagerDelegate?
    
    
    
    let lyricsURL = "https://api.lyrics.ovh/v1/"
    
    func fetchLyrics(artist : String, title : String){
        
        var newArtist : String{
            let res = artist.replacingOccurrences(of: " ", with:   "%20")
            return res.replacingOccurrences(of: ",", with:   "")
        }
        
        var newTitle : String{
            let res = title.replacingOccurrences(of: " ", with:   "%20")
            return res.replacingOccurrences(of: ",", with: "")
        }
        
        let urlString = "\(lyricsURL)\(newArtist)/\(newTitle)"
        performRequest(with : urlString)
    }
    
    func performRequest(with urlString : String){
        //1.create url
        if let url = URL(string: urlString){
            //2.create a URLsession
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWitherror(error: error!)
                    return
                }
                if let safeData = data{
                    if let song = self.parseJSON(safeData){
                        self.delegate?.didUpdateText(_SongManager: self, song: song)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ songData : Data) -> SongModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(SongData.self, from: songData)
            let text = decodedData.lyrics
            let song = SongModel(lyrics: text)
            return song
        }catch{
            delegate?.didFailWitherror(error: error)
            return nil
        }
    }
}

