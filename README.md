NavigationControllerWithBlocks
==============================

The UINavigationController missing API ! (push / pop with optional completionBlock). 
The implementation use the navigationController delegate on UINavigationController itself.


This project provides : 
* A completionBlock to manage your push/pop events,
* A safe way to push/pop multiple controllers at the same times.
```objc

   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
   [self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
```
* No more "Nested pop animation can result in corrupted navigation bar", 
* No more "Finishing up a navigation transition in an unexpected state. Navigation Bar subview tree might get corrupted."
* No more crash because of deallocated controllers between your multiple animations.

![Image](./screenshots/demo.gif)

New methods 
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

Swizzled methods 
---------------------------------------------------
```objc
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; 
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
```

Usage UINavigationController+CompletionBlock
-------------------------------------------------------------
* Just call the new pop/push methods 
```objc
[self.navigationController popViewControllerAnimated:YES withCompletionBlock:NULL];
[self.navigationController pushViewController:vc animated:YES withCompletionBlock:^(BOOL successful) {
   NSLog(@"Hi ! Push done !");
}];
```

* call Apple the new push/pop API. Using method swizzling, will call the new API with default NULL completionBlock
```objc
[self.navigationController popViewControllerAnimated:YES];
[self.navigationController pushViewController:vc animated:YES];
```

Installation using pods 
-------------------------------------------------------------
Just add the following line in your podfile

	pod 'NavigationControllerWithBlocks'
	

![Image](./screenshots/demo.png)


