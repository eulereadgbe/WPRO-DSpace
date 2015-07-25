package org.dspace.content.authority.mesh;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class MeSHTermsLoader {
    private static String values[] = null;

    public static synchronized String[] load() {
        if (values != null) {
            return values;
        }

        Set<String> meshTerms = new HashSet(MeSHMapLoader.load().values());
        values = meshTerms.toArray(new String[meshTerms.size()]);
        Arrays.sort(values);

        return values;
    }
}
