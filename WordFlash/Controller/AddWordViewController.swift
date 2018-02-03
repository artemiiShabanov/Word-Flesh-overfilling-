import Foundation
import UIKit
import RealmSwift


class AddWordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let dict: Dictionary = Dictionary.sharedInstance
    var alreadyHaveWords: [String] = []
    var filteredWords: [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for word in realm.objects(Word.self) {
            alreadyHaveWords.append( word.word )
        }
        filteredWords = dict.words
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    
    // MARK: tableView section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWords.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableCell.reuseId) as? WordTableCell
            else { fatalError("Fatal error") }
        cell.set(word: filteredWords[indexPath.row])
        cell.set(fontColor: alreadyHaveWords.contains(cell.WordLabel.text!) ? .gray : .white)
        cell.set(color: Color.dolphin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //adding word to realm
        let word = Word()
        word.word = filteredWords[indexPath.row]
        word.definition = dict[word.word]
        if !alreadyHaveWords.contains(word.word) {
            try? realm.write {
                realm.add(word)
            }
            self.dismiss(animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: searchBar section
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filtering words
        if searchText.count == 0 {
            filteredWords = dict.words
        } else {
            filteredWords = allWords.findWordsWithPrefix(prefix: searchText)
        }
        tableView.reloadData()
    }
    
    
    // MARK: custom button
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

