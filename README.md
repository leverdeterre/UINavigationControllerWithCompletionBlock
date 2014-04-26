NavigationControllerWithBlocks
==============================

The UINavigationController missing methods ! (push / pop with optional completionBlock). 
The implementation use the navigationController delegate on UINavigationController itself.

Added methods 
---------------------------------------------------

```objc
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;

- (void)popViewControllerAnimated:(BOOL)animated withCompletionBlock:(JMONavCompletionBlock)completionBlock;
```

Usage
-------------------------------------------------------------
* using category (UINavigationController+CompletionBlock), just call the method to activate auto delegation.
```objc
- (void)activateCompletionBlock;
```


* using JMONavigationController (subclassing UINavigationController), nothing to be done, default initalizers are overided to call activateCompletionBlock.

