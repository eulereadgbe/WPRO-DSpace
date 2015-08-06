package org.dspace.content.authority.mesh;

import org.dspace.core.ConfigurationManager;

import java.io.*;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class MeSHMapLoader {
    static private Map<String, Map<String, String>> cachedTrees = new HashMap<String, Map<String, String>>();

    static private String treeFileName = null;
    static private String testTreeFileName = null;

    static public Map<String, String> load() {
        return MeSHMapLoader.load(null);
    }

    static public Map<String, String> load(Locale loc) {
        String language;

        if (loc == null) {
            language = Locale.ENGLISH.getLanguage();
        } else {
            language = loc.getLanguage();
        }

        synchronized (cachedTrees) {
            if (cachedTrees.containsKey(language)) {
                return cachedTrees.get(language);
            }

            InputStream is = getInputStream(language);
            if (is == null && language.startsWith("en")) {
                is = getInputStream(null);
            }

//            File treeFile = new File(treeFileName + "_" + language);
//            if (!treeFile.exists() && language.startsWith("en")) {
//                treeFile = new File(treeFileName);
//            }


            if (is == null) {
                return null;
            }

            try {
                Map<String, String> meshTree = new HashMap<String, String>();

                BufferedReader meshReader = new BufferedReader(new InputStreamReader(is));
                //new BufferedReader(new FileReader(treeFile));
                
                String meshLine = meshReader.readLine();
                while (meshLine != null) {
                    String[] meshLineArray = meshLine.split(";");
                    if (meshLineArray.length == 2) {
                        meshTree.put(meshLineArray[1], meshLineArray[0]);
                    }

                    meshLine = meshReader.readLine();
                }

                cachedTrees.put(language, meshTree);
                return meshTree;
            } catch (IOException ioe) {
                return null;
            }
        }
    }

    static private InputStream getInputStream(String language) {
        try {
            if (language != null) {
                if (testTreeFileName != null) {
                    return MeSHMapLoader.class.getClassLoader().getResourceAsStream(testTreeFileName + "_" + language);
                }

                initTreeFileName();
                return new FileInputStream(treeFileName + "_" + language);

            } else {
                if (testTreeFileName != null) {
                    return MeSHMapLoader.class.getClassLoader().getResourceAsStream(testTreeFileName);
                }

                initTreeFileName();
                return new FileInputStream(treeFileName);
            }
        } catch (IOException ioe) {
            return null;
        }
    }

    static private void initTreeFileName() {
        treeFileName = ConfigurationManager.getProperty("mesh.tree.file");
    }

    static void setTestTreeFileName(String name) {
        testTreeFileName = name;
    }
}
