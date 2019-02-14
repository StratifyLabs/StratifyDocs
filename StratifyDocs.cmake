


#[[

brew install doxygen
npm i moxygen -g
pip install mkdocs

#]]

# Build the Docs using cmake -P StratifyDocs.cmake

# Need to generate all the docs

execute_process(COMMAND doxygen WORKING_DIRECTORY ../StratifyOS)
execute_process(COMMAND doxygen WORKING_DIRECTORY ../StratifyAPI)

execute_process(COMMAND moxygen --html-anchors --groups --templates templates/moxygen/cpp --output docs/StratifyOS/%s.md StratifyOS/xml)
execute_process(COMMAND moxygen --html-anchors --templates templates/moxygen/cpp --output docs/StratifyAPI.md StratifyAPI/xml)
