package org.dspace.content.authority.mesh;

import org.apache.commons.lang.StringUtils;
import org.dspace.content.*;
import org.dspace.content.Collection;
import org.dspace.content.authority.AuthorityVariantsSupport;
import org.dspace.content.authority.Choice;
import org.dspace.content.authority.ChoiceAuthority;
import org.dspace.content.authority.Choices;
import org.dspace.core.ConfigurationManager;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;

public class MeSHAuthority implements ChoiceAuthority {
    private static String values[] = MeSHTermsLoader.load();

    public Choices getMatches(String field, String text, Collection collection, int start, int limit, String locale) {
        String lwrText = text.toLowerCase();
        Set<Choice> choices = new HashSet<Choice>();
        for (int i = 0; i < values.length && (choices.size() < limit || limit < 0); ++i)
        {
            if (values[i].toLowerCase().startsWith(lwrText)) {
                choices.add(new Choice(values[i], values[i], values[i])); // replace last with getLabel(values[i], locale)
            }
        }

        if (choices.size() == 0) {
            return new Choices(Choices.CF_NOTFOUND);
        }

        Choice[] v = choices.toArray(new Choice[choices.size()]);
        return new Choices(v, 0, v.length, Choices.CF_AMBIGUOUS, false, 0);
    }

    public Choices getBestMatch(String field, String text, Collection collection, String locale) {
        String lwrText = text.toLowerCase();
        String bestMatch = null;
        for (int i = 0; i < values.length; ++i)
        {
            // If the text matches exactly a value, return an accepted match
            if (values[i].toLowerCase().equals(lwrText)) {
                Choice[] matches = { new Choice(values[i], values[i], values[i]) };
                return new Choices(matches, 0, matches.length, Choices.CF_ACCEPTED, false, 0);
            }

            // Prioritize items starting with the value, otherwise anything that contains it
            if (values[i].toLowerCase().startsWith(lwrText)) {
                // Do we already have a best match?
                if (!StringUtils.isEmpty(bestMatch)) {
                    if (values[i].length() < bestMatch.length()) {                  // If the test value is shorter than the bestMatch, it is a better match
                        bestMatch = values[i];
                    } else if (!bestMatch.toLowerCase().startsWith(lwrText)) {      // Otherwise if the bestMatch doesn't start with the term, this is better
                        bestMatch = values[i];
                    }
                } else {
                    bestMatch = values[i];                                          // No best match, this is best match
                }
            } else if (values[i].toLowerCase().contains(lwrText)) {                 // For anything that contains the term
                if (!StringUtils.isEmpty(bestMatch)) {                              // If we have a bestMatch
                    if (!bestMatch.toLowerCase().startsWith(lwrText)) {             // - and the bestMatch doesn't start with the term
                        if (values[i].length() < bestMatch.length()) {              // - and the test value is shorter than the best match
                            bestMatch = values[i];                                  // Then this is the best match
                        }
                    }
                } else {
                    bestMatch = values[i];                                          // No best match, this is best match
                }
            }

        }

        if (StringUtils.isEmpty(bestMatch)) {
            return new Choices(Choices.CF_NOTFOUND);
        }

        Choice[] matches = { new Choice(bestMatch, bestMatch, bestMatch) };
        return new Choices(matches, 0, matches.length, Choices.CF_AMBIGUOUS, false, 0);
    }

    public String getLabel(String field, String key, String locale) {
        return MeSHTranslator.lookup(key, locale);
    }
}
