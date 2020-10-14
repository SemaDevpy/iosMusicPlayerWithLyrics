//
//  ViewController.swift
//  musicWithLyricsPlayer
//
//  Created by Syimyk on 10/13/20.
//  Copyright © 2020 Syimyk. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var songInfo = SongInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }


}


//MARK: - UITableViewDataSource
extension FirstViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songInfo.songsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = songInfo.songsArray[indexPath.row].title
        cell.detailTextLabel?.text =  songInfo.songsArray[indexPath.row].singer
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension FirstViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToLyrics", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondViewController
        if let indexPath = table.indexPathForSelectedRow{
            destinationVC.singer = songInfo.songsArray[indexPath.row].singer
            destinationVC.song = songInfo.songsArray[indexPath.row].title
        }
    }

}


