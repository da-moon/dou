/****
  Shared library helper for loading linux scripts from the resources folder
****/

def call(String filename) {
  def scriptTxt = libraryResource "com/citizensbank/scripts/terraform/$filename"
  writeFile file: filename, text: scriptTxt
  sh "chmod a+x ./$filename"
}
