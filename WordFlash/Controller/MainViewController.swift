import UIKit
import Koloda

enum SegueTargetMain {
    case History 
    case Favorite
    case Add
}

class MainViewController: UIViewController{
    
    var words:[Word] = []
    var shuffledWords:[Word] = []
    var segueTarget:SegueTargetMain?
    
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet var designView: UIView!
    
    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.backgroundColor = Color.dolphin
        words = realm.objects(Word.self).filter(NSPredicate(format: "isAddedByUser == true and inHistory == false")).map{$0}
        shuffledWords = (words + Functions.getRandomWords(on: 5)).shuffled()
        kolodaView.resetCurrentCardIndex()
        kolodaView.reloadData()
        refreshButton.isHidden = true
        refreshButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loading words from db
        words = realm.objects(Word.self).filter(NSPredicate(format: "isAddedByUser == true and inHistory == false")).map{$0}
    }
    
    
    //MARK: custom buttons
    
    @IBAction func addWord(_ sender: Any) {
        segueTarget = .Add
        self.performSegue(withIdentifier: "AddWordSegue", sender: self)
    }
    
    @IBAction func showFavorite(_ sender: Any) {
        segueTarget = .Favorite
        self.performSegue(withIdentifier: "TableSegue", sender: self)
    }
    
    @IBAction func showHistory(_ sender: Any) {
        segueTarget = .History
        self.performSegue(withIdentifier: "TableSegue", sender: self)
    }
    
    @IBAction func refresh(_ sender: Any) {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        UIView.animate(withDuration: 0.5, delay: 0.45, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }, completion: {(finished:Bool) in
            self.refreshButton.isHidden = true
            self.refreshButton.isEnabled = false
            self.update(self.kolodaView)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueTarget! {
        case .Add:
            break;
        case .History:
            guard let destination = segue.destination as? WordsTableViewController
                else {fatalError("Some Error")}
            destination.state = .History
        case .Favorite:
            guard let destination = segue.destination as? WordsTableViewController
                else {fatalError("Some Error")}
            destination.state = .Favorite
        }
    }
    
    
    // MARK: for kolodaView
    private func update(_ koloda: KolodaView) {
        words = realm.objects(Word.self).filter(NSPredicate(format: "isAddedByUser == true and inHistory == false")).map{$0}
        shuffledWords = (words + Functions.getRandomWords(on: 5)).shuffled()
        koloda.resetCurrentCardIndex()
        koloda.reloadData()
    }
}


// MARK: KolodaViewDelegate

extension MainViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        refreshButton.isHidden = false
        refreshButton.isEnabled = true
    }
}


// MARK: KolodaViewDataSource

extension MainViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return shuffledWords.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card = CardView()
        card.delegate = self
        card.construct(for: shuffledWords[index])
        return card
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection){
        if direction == .left{
            try? realm.write {
                shuffledWords[index].remember()
            }
        } else if direction == .right {
            try? realm.write {
                shuffledWords[index].dontRemember()
            }
        }
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }

}


// MARK: star pressed delegate
extension MainViewController: StarPressedDelegate {
    func starPressed(for word:String) {
        try! realm.write{
            if let model = realm.object(ofType: Word.self, forPrimaryKey: word){
                model.changeFavoriteState()
            }
            else {
                let model = Word()
                model.word = word
                model.definition = Dictionary.sharedInstance[word]
                model.isAddedByUser = false
                model.isFavorite = true
                realm.add(model)
            }
        }
    }
}



