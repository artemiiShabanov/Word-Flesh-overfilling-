import UIKit

class HistoryWordViewController: UIViewController {
    
    var word:Word?
    
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contentViewHist: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    
    //MARK: ViewController stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLabel.text = word?.word
        definitionLabel.text = word?.definition
        contentViewHist.layer.borderColor = Color.alien.cgColor
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: definitionLabel.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: custom button
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
