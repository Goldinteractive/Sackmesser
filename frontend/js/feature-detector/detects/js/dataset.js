export default function () {
  try {
    eval('(function* asdf(){})()')
    return true
  } catch (e) {
    return false
  }
}
