import Foundation
import UIKit
import RealmSwift

enum State {
    case History
    case Favorite 
}

enum SegueTarget {
    case Add
    case Word
    case Login
    case Logout
}

class WordsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var words: Results<Word>!
    var state: State?
    var word: Word?
    var segueTarget: SegueTarget = .Add
    
    @IBOutlet weak var bar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoButton: UIButton!
    @IBOutlet weak var histButton: UIButton!
    @IBOutlet var designView: UIView!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        designView.backgroundColor = Color.dolphin
        tableView.sectionIndexBackgroundColor = Color.dolphin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if state == .History {
            histButton.setImage(#imageLiteral(resourceName: "histline"), for: .normal)
            favoButton.setImage(#imageLiteral(resourceName: "defstar"), for: .normal)
            histButton.isEnabled = false
            favoButton.isEnabled = true
            bar.backgroundColor = Color.alien
        } else {
            favoButton.setImage(#imageLiteral(resourceName: "favstar"), for: .normal)
            histButton.setImage(#imageLiteral(resourceName: "defline"), for: .normal)
            favoButton.isEnabled = false
            histButton.isEnabled = true
            bar.backgroundColor = Color.gold
        }
        bar.topItem?.title = (state == .History) ? "History" : "Favorite"
        words = realm.objects(Word.self).filter(NSPredicate(format: state == .History ? "inHistory == true" : "isFavorite == true"))
        tableView.reloadData()
    }
    
    
    
    // MARK: tableView section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WordTableCell.reuseId) as? WordTableCell
            else {
                fatalError("Fatal error")
        }
        cell.set(word: words[indexPath.row].word)
        cell.set(color: Color.dolphin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        word = words[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        segueTarget = .Word
        self.performSegue(withIdentifier: (state == .Favorite) ? "FavoriteSegue" : "HistorySegue", sender: self)
    }
    
    
    
    // MARK: custom buttons
    
    @IBAction func log(_ sender: Any) {
        if defaults.object(forKey: "Username") == nil {
            segueTarget = .Login
            self.performSegue(withIdentifier: "LogSegue", sender: self)
        } else {
            segueTarget = .Logout
            self.performSegue(withIdentifier: "LogoutSegue", sender: self)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addWord(_ sender: Any) {
        segueTarget = .Add
        self.performSegue(withIdentifier: "AddWordSegue", sender: self)
    }
    @IBAction func showOtherList(_ sender: Any) {
        state = (state == .History) ? .Favorite : .History
        self.viewDidAppear(false)
    }
    
    
    
    // MARK: prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueTarget {
        case .Word:
            if state == .History {
                guard let destination = segue.destination as? HistoryWordViewController
                    else { fatalError("Some Error") }
                destination.word = word
            }
            else {
                guard let destination = segue.destination as? FavoriteWordViewController
                    else { fatalError("Some Error") }
                destination.word = word
            }
        case .Add:
            break
        case .Login:
            guard let destination = segue.destination as? LoginViewController
                else { fatalError("Some Error") }
            destination.wasLoggedIn = false
            break
        case .Logout:
            break
        }
    }
    
}
