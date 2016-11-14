package org.dspace.content.authority.mesh;

import org.apache.commons.lang.StringUtils;
import org.dspace.core.ConfigurationManager;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class MeSHTranslator {
    private static Map<String, Map<String, String>> translationsLanguageMap = new HashMap<String, Map<String, String>>();

    public static String lookup(String term, String locale) {
        Locale loc = null;

        if (!StringUtils.isEmpty(locale)) {
            loc = new Locale(locale);
        }

        if (loc != null && !Locale.ENGLISH.equals(loc)) {
            Map<String, String> locTranslations = getTranslations(loc);

            synchronized (locTranslations) {
                if (locTranslations.containsKey(term)) {
                    return locTranslations.get(term);
                }

                String value = lookupBabelMeSH(term, loc);
                if (!StringUtils.isEmpty(value)) {
                    locTranslations.put(term, value);
                    return value;
                }
            }
        }

        return term;
    }

    public static String lookupBabelMeSH(String term, Locale loc) {
        try {
            String lang = getLang(loc);
            URLConnection babelMeshConn = (new URL("https://babelmesh.nlm.nih.gov/mesh_trans.php?oterm=" + URLEncoder.encode(term, "UTF-8") + "&in=ENG&out=" + lang)).openConnection();
            babelMeshConn.setConnectTimeout(5000);
            babelMeshConn.setReadTimeout(5000);

            BufferedReader in = new BufferedReader(new InputStreamReader(babelMeshConn.getInputStream(), "UTF-8"));
            String value = in.readLine();
            in.close();

            if (!StringUtils.isEmpty(value)) {
                return value;
            }
        } catch (MalformedURLException mue) {

        } catch (IOException ioe) {

        }

        return null;
    }

    static Map<String, String> getTranslations(Locale loc) {
        if (translationsLanguageMap.containsKey(loc.getLanguage())) {
            return translationsLanguageMap.get(loc.getLanguage());
        }

        synchronized (translationsLanguageMap) {
            String transBaseName = null;
            if (!translationsLanguageMap.containsKey(loc.getLanguage())) {
                try {
                    transBaseName = ConfigurationManager.getProperty("mesh.term.translation");
                } catch (Exception e) {
                    // Ignore - we'll just call BabelMesh directly
                }
                
                if (transBaseName != null) {
                    translationsLanguageMap.put(loc.getLanguage(), loadTranslations(transBaseName + "_" + loc.getLanguage()));
                } else {
                    translationsLanguageMap.put(loc.getLanguage(), new HashMap<String, String>());
                }
            }
        }

        return translationsLanguageMap.get(loc.getLanguage());
    }

    private static Map<String, String> loadTranslations(String filename) {
        Map<String, String> translations = new HashMap<String, String>();

        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(filename), "UTF8"));
            String line = reader.readLine();
            while (line != null) {
                String[] terms = line.split("::");
                if (terms.length > 1) {
                    translations.put(terms[0], terms[1]);
                }

                line = reader.readLine();
            }
        } catch (FileNotFoundException fnfe) {
            // Ignore - just call BabelMeSH directly
        } catch (IOException ioe) {
            // Ignore - just call BabelMeSH directly
        }

        return translations;
    }

    private static String getLang(Locale loc) {
        if (loc != null) {
            if (Locale.FRENCH.getLanguage().equals(loc.getLanguage())) {
                return "FRE";
            }

            if (Locale.CHINESE.getLanguage().equals(loc.getLanguage())) {
                return "CHN";
            }

            if (Locale.SIMPLIFIED_CHINESE.getLanguage().equals(loc.getLanguage())) {
                return "CHN";
            }
        }

//  ENG English</option>
//	ARA Arabic</option>
//	CHN Chinese</option>
//	FRE French</option>
//	POR  Portuguese</option>
//	RUS  Russian</option>
//	SPA  Spanish</option>

        return loc.getISO3Language().toUpperCase();
    }

    public static void main(String[] args) throws IOException
    {
        String[] meshTerms = MeSHTermsLoader.load();
        String transBaseName = ConfigurationManager.getProperty("mesh.term.translation");

        
        String locales = ConfigurationManager.getProperty("webui.supported.locales");
        if (!StringUtils.isEmpty(locales)) {
            String[] localesArray = locales.split("\\s*,\\s*");
            for (String locStr : localesArray) {
                Locale loc = new Locale(locStr);
                if (!Locale.ENGLISH.getLanguage().equals(loc.getLanguage())) {
                    Map<String, String> locTranslations = getTranslations(loc);

                    System.out.println("Generating translations: " + loc.getLanguage());
                    PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(transBaseName + "_" + loc.getLanguage()), "UTF8"));

                    int count = 0;
                    int lastPercent = 0;
                    for (String term : meshTerms) {
                        if (!term.equals(locTranslations.get(term))) {
                            String value = lookupBabelMeSH(term, loc);
                            if (StringUtils.isEmpty(value)) {
                                locTranslations.put(term, term);
                            } else {
                                locTranslations.put(term, value);
                            }
                        }

                        if (locTranslations.containsKey(term)) {
                            out.println(term + "::" + locTranslations.get(term));
                        }

                        count++;
                        if (lastPercent != ((count * 100) / meshTerms.length)) {
                            lastPercent = ((count * 100) / meshTerms.length);
                            if ( (lastPercent % 5) == 0 ) {
                                System.out.println("Translated: " + count + " terms (" + lastPercent + "%)");
                            }
                        }
                    }

                    out.close();

//                    System.out.println("Writing translations");


//                    for (Map.Entry<String, String> translation : locTranslations.entrySet()) {
//                        out.println(translation.getKey() + "::" + translation.getValue());
//                    }


                    System.out.println("Finished generating translations: " + loc.getLanguage());
                }
            }
        }
    }
}
