NavigationControllerWithBlocks
==============================

The UINavigationController missing methods ! (push / pop with optional completionBlock). 
The implementation use the navigationController delegate on UINavigationController itself.

![Image](./screenshots/demo.png)

This project provides : 
* A completionBlock to manage your push/pop events,
* A safe way to push/pop multiple controllers at the same times.
```objc

   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
```
No crash !!

Added methods 
---------------------------------------------------

```objc
- (void)pushViewController:(UIViewController *)viewController 
                 animated:(BOOL)animated 
      withCompletionBlock:(JMONavCompletionBlock)completionBlock;

- (void)popViewControllerAnimated:(BOOL)animated 
              withCompletionBlock:(JMONavCompletionBlock)completionBlock;
- (void)popToRootViewControllerAnimated:(BOOL)animated
                    withCompletionBlock:(JMONavCompletionBlock)completionBlock;
```

Usage
-------------------------------------------------------------
* using category (UINavigationController+CompletionBlock), just call the method to activate auto delegation.
```objc
- (void)activateCompletionBlock;
```
and use the pop/push methods 
```objc
[self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
[self.navigationController pushViewController:vc animated:YES withCompletionBlock:^(BOOL successful) {
   NSLog(@"Hi ! Push done !");
}];
```

* using JMONavigationController (subclassing UINavigationController), nothing to be done, default initalizers are overided to call activateCompletionBlock.
but use the pop/push methods 
```objc
[self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
[self.navigationController pushViewController:vc animated:YES withCompletionBlock:^(BOOL successful) {
   NSLog(@"Hi ! Push done !");
}];
```

