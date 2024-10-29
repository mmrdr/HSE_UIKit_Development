# *Answers to questions from the homework*
## ***What issues prevent us from using storyboards in real projects?***
* **Heavy files:** Large storyboards slow down Xcode — the project takes a long time to open, the storyboard may lag when editing.
* Problems with **compiling and updating** the interface in the simulator — storyboard is often "buggy", and changes are not always displayed correctly without restarting.
* **Different** interface states (for example, different content appears on the screen depending on the data) are difficult to maintain via storyboard.
## ***What does the code on lines 25 and 29 do?***
* **TranslatesAutoresizingMaskIntoConstraints** is a property that controls whether the system needs to automatically create Auto Layout constraints based on the old Auto-Resizing Mask. In our case, it is **false**, then we completely manage the restrictions manually.
* The **addSubview** method is used to add a single view as a child element in another view (superview). This allows you to create a hierarchy of interfaces in which one element becomes a container for another.
## ***What is a safe area layout guide?***
**safeAreaLayoutGuide** is an object that defines a safe knee to move on the user's screen by selecting a crosshair with system elements.
## ***What is [weak self] on line 23 and why it is important?***
[weak self] is a capture list used inside closures to prevent strong reference cycles. In this example, it is necessary to avoid memory leaks when accessing self inside the closure associated with the slider.
In Swift, objects such as closures by default create strong references to any variables they use, including self. If the closure persists inside an object, for example in your CustomSlider, this can lead to a retain cycle — a situation where the closure holds the object and the object holds the closure.
### ***How it works?***
When using [weak self], the closure creates a weak reference to self, which allows the object to be freed from memory if no one else references it.
If the object was released before the closure was called, self will become nil. Therefore, optional binding (self?) is often used in code to make sure that the object still exists.
## ***What does clipsToBounds mean?***
The ClipToBounds property determines whether the view will crop its subviews along the boundaries of its frame.
* If clipToBounds = true: Child elements that go beyond the frame of the parent view will be clipped.
* If clipsToBounds = false: Child elements may extend beyond the frame and be visible.
## ***What is the valueChanged type? What is Void and what is Double?***
valueChanged is a closure in a custom Slider class that takes a Double as an argument and returns Void.
* Void: shows that the closure simply performs an action, for example, updates the background color of the view depending on the new value of the slider.
* Double: transmits the current position of the slider.