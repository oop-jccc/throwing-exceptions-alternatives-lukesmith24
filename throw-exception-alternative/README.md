# throwing-exceptions-alternatives

============================

* Treat errors as values and return a value.
  * When appropriate, return a nullable type, empty collection, or empty string.
  * Return something like a `Result`.
  * Benefits:
    * Throwing exceptions is expensive
    * We can make our methods pure, which means same input always gives the same output with no side effects.
    * This allows our code to be more predictable; we call a method and it always give a value and never throws an exception.
* Testing
  * This makes it easier to test our code.
    * Give a method an input, then assert on an output. No longer need to expect a throw on the output.
      ```csharp
         Assert.Throws<NegativeNumberException>(() => _ = GetMilesPerGallon(miles: -1.0, gallons: 5.0));
      ```
* When are throwing exceptions appropriate?
  * Ensuring the application object graph is valid during startup.
    * Throwing null reference exceptions in constructors.
  * Validating input when setting properties.
  * TBD
