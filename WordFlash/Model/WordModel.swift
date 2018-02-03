import RealmSwift

class Word: Object {
    @objc dynamic public var word = ""
    @objc dynamic public var definition = ""
    @objc dynamic public var inHistory:Bool = false
    @objc dynamic public var isFavorite:Bool = false
    @objc dynamic public var isAddedByUser:Bool = true
    @objc dynamic public var streak = 0
    
    func remember() {
        streak += 1
        if streak == 3 {
            inHistory = true
        }
    }
    
    func dontRemember() {
        streak = 0
    }
    
    func changeFavoriteState() {
        isFavorite = !isFavorite
    }
    
    override static func primaryKey() -> String? {
        return "word"
    }
}
