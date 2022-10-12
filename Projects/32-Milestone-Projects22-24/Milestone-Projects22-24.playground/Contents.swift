//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

//Challenge 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .white

let label = UILabel()
label.text = "CHALLENGE"
label.font = UIFont.systemFont(ofSize: 32)
label.textAlignment = .center
label.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(label)

NSLayoutConstraint.activate([
    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])

PlaygroundPage.current.liveView = view
view.bounceOut(duration: 1)


// Challenge 2
extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 1...self {
            closure()
        }
    }
}

5.times { print("Hello!") }

var count = 0
7.times { count += 1 }
assert(count == 7)


// Challenge 3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}

var numbers = [1, 2, 3, 4, 3]
numbers.remove(item: 3)
assert(numbers == [1, 2, 4, 3])
