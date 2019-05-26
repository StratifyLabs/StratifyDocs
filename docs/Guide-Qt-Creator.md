# Using Qt Creator for C/C++ Code Editing

There are many code editors out there and you can use any one you like for Stratify OS applications and OS packages.  All projects can build easily using `cmake` and `make` from the command line.

If you don't have a C/C++ code editor that you are in love with or just want to try something new, this is why Qt Creator is a great option.

- Free (there is a commercial version but the free version is perfect for Stratify OS)
- Great cmake integration
- Excellent C++ code model for code completion and lookup

## Installing the Free Version of Qt Creator

Qt Creator can be downloaded from [the Qt website](https://www.qt.io/download). The page touts the differences between the commercial and open source versions. If you are just using Qt Creator to edit code, the LGPL has no impact on what you are doing. The license only applies if you are building applications using the Qt cross-platform libraries.

Once you download and run the online installer, you will have the option to install Qt Creator along with other Qt products. For code editing, you just need Qt Creator.

## CMake Integration


Once you have Qt Creator running, you can open a Stratify OS project by simply clicking "File" then "Open File or Project" and selecting the "CMakeLists.txt" file within the project you want to open.

> ** A Quick Note**
>
> Before you open your first project, you will want to disable the `ClangCodeModel` plugin. Otherwise, you will see errors like the ones below. You can edit the plugins using "Qt Creator" then "About Plugins" on Mac and "Help" then "About Plugins" on Windows.
>
> ![Disable clang code model](img/qt-creator-clang-code-model-errors.png)


From there you will need to configure the project. You can use the default kit. Deselect all build configurations except the default then select (create if needed) the folder `<project>/cmake_arm` as the build folder.

![Configure HelloWorld](img/qt-creator-configure-project.png)

Qt Creator will use CMake to figure out all the paths and include files as well as parse all the build configurations. From here you are ready to start building.

You can get much better build times on multi-core processors by clicking on "Projects" in the left-most panel and adding `-j8` (or `-j<some value>` that is more than one) to tell `make` to build multiple files in parallel.

![Configure HelloWorld](img/qt-creator-build-jobs.png)

## C++ Code Completion and Lookup

Qt Creator and `cmake` take care of all the code model parsing. You will notice that when you start typing code, Qt Creator will make suggestions to complete the function or method and provide a peek at the arguments.

You can also right click on almost any part of the code and jump to the header or source.

# Conclusion

If you try it and don't like it, you can always give Eclipse, Sublime, VS Code, or Atom a try.

