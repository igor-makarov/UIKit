import PromiseKit
import UIKit

#if !os(tvOS)

public enum PMKError: Error {
    case noImageFound
}

extension UIViewController {
    /// Presents the UIImagePickerController, resolving with the user action.
    public func promise(_ vc: UIImagePickerController, animate: PMKAnimationOptions = [.appear, .disappear], completion: (() -> Void)? = nil) -> Promise<UIImage> {
        let animated = animate.contains(.appear)
        let proxy = UIImagePickerControllerProxy()
        vc.delegate = proxy
        vc.mediaTypes = ["public.image"]  // this promise can only resolve with a UIImage
        present(vc, animated: animated, completion: completion)
        return proxy.promise.then(on: nil) { info -> UIImage in
            if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
                return img
            }
            if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
                return img
            }
            throw PMKError.noImageFound
        }.always {
            vc.presentingViewController?.dismiss(animated: animated, completion: nil)
        }
    }

    /// Presents the UIImagePickerController, resolving with the user action.
    public func promise(_ vc: UIImagePickerController, animate: PMKAnimationOptions = [.appear, .disappear], completion: (() -> Void)? = nil) -> Promise<[String: Any]> {
        let animated = animate.contains(.appear)
        let proxy = UIImagePickerControllerProxy()
        vc.delegate = proxy
        present(vc, animated: animated, completion: completion)
        return proxy.promise.always {
            vc.presentingViewController?.dismiss(animated: animated, completion: nil)
        }
    }
}

@objc private class UIImagePickerControllerProxy: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let (promise, seal) = Promise<[String : Any]>.pending()
    var retainCycle: AnyObject?

    required override init() {
        super.init()
        retainCycle = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        seal.fulfill(info)
        retainCycle = nil
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        seal.reject(NSError.cancelledError)
        retainCycle = nil
    }
}

#endif
