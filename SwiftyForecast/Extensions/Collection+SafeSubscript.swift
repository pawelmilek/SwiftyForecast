extension Array {
  
  public subscript(safe index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
    guard index >= 0, index < endIndex else {
      return defaultValue()
    }
    
    return self[index]
  }
  
  public subscript(safe index: Int) -> Element? {
    guard index >= 0, index < endIndex else {
      return nil
    }
    
    return self[index]
  }
  
}
