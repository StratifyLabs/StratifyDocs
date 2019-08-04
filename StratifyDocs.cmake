


#[[

brew install doxygen
npm i moxygen -g

#]]

# Build the Docs using cmake -P StratifyDocs.cmake

# Need to generate all the docs

execute_process(COMMAND doxygen WORKING_DIRECTORY ../StratifyOS)
execute_process(COMMAND doxygen WORKING_DIRECTORY ../StratifyAPI)

execute_process(COMMAND moxygen --linksuffix / --linkprefix / --html-anchors --groups --templates ../templates/moxygen/cpp --output reference/StratifyOS/%s.md ../StratifyOS/xml WORKING_DIRECTORY content)
execute_process(COMMAND moxygen --linksuffix / --linkprefix / --relativeUrlPath testing --html-anchors --classes --templates ../templates/moxygen/cpp --output reference/StratifyAPI/%s.md ../StratifyAPI/xml WORKING_DIRECTORY content)
