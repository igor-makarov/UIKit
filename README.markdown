# PromiseKit UIKit Extensions ![Build Status]

This project adds promises to Apple’s UIKit framework.

# Not provided

We do no longer provide trivial promises with PromiseKit, here is the code you may need that you can simply copy and paste into your projects:

```swift
Gurantee { seal in
    UIView.animate(withDuration: 0.3, animations: {
        //…
    }, completion: seal)
}
```

```objective-c
[AnyPromise promiseWithResolverBlock:^(id resolve) {
    [UIView animateWithDuration:duration animations:^{
        //…
    } completion:^(BOOL finished) {
        resolve(@(finished));
    }];
}];
```


## CococaPods

```ruby
pod "PromiseKit/UIKit" ~> 4.0
```

The extensions are built into `PromiseKit.framework` thus nothing else is needed.

## Carthage

```ruby
github "PromiseKit/UIKit" ~> 1.0
```

The extensions are built into their own framework:

```swift
// swift
import PromiseKit
import PMKUIKit
```

```objc
// objc
@import PromiseKit;
@import PMKUIKit;
```


# Modal View Controllers

You can wrap presentation of a View Controller in a promise like so:

```swift
class MyViewController {
    let seal: Sealant<Something>

    private init(_ seal: Sealant<Something>) {
        self.seal = seal
        super.init(nibName: nil, bundle: nil)
    }

    static func promise(in parentViewController: UIViewController) -> Promise<Something> {
        let (promise, seal) = Promise<Something>.pending() 
        let vc = MyViewController(seal)
        show(vc, in: parentViewController)
        return promise
    }

    private func done() {
        dismissViewController(animated: true)
        seal.fulfill(something)
    }
}
```

Consider using a `Guarantee` if your modal operation cannot fail. 


# Important Caveat

Since iOS 10 any framework that uses `UIImagePickerController` forces the underlying app to specify why in its
`Info.plist`, thus if you use `PromiseKit/UIKit` you will need to specify this key. Since for Swift this
subspec only contains an extension for `UIImagePickerController` this really is only a consideration for objc
users. You may wish to copy and paste the single `.m` file into your project rather than use this subspec.


[Build Status]: https://travis-ci.org/PromiseKit/UIKit.svg?branch=master
