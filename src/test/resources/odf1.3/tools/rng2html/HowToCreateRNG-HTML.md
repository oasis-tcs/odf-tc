# How to create RNG files as HTML files with Line Numbers

0. If necessary, indent RNG with 2 spaces (comments were indented as well).
1. Rename RNG file with HTML suffix and open it in browser.
2. Choice from the context menu show source
    * Original RNG file opened in Chrome browser has lines as
        <tr>
            <td class="line-number" value="61"></td>
            <td class="line-content">&lt;define name="ds-signature"&gt;</td>
        </tr>
    * RNG with named with HTML suffix opened in Chrome browser is providing more styles:
        <tr>
            <td class="line-number" value="61"></td>
            <td class="line-content">
            <span class="html-tag">&lt;define
                <span class="html-attribute-name">name</span>="
                <span class="html-attribute-value">ds-signature</span>"&gt;</span>
            </td>
        </tr>
3. From the 'source' window, choose again from the context menu 'inspect'
4. From the shown nodes, choose the body element and from the context menu choose 'copy element'
5. Copy body element without closing tag into the [template](template.html)
6. Rename the template according to RNG and adapt new settings (e.g. release date)
7. Make it XML by replacing &lt;br&gt; with &lt;br/&gt; (likely that's all)
8. (Better do step 0. And only necessary for ODF 1.2 parts: Change in HTML correct indent from tab to 4 spaces - easy with UltraEdit ^t)
9. 2DO: Check if the 'value' have to be manually replaced with 'id'
10. Trigger an [XSL transformation](addRefs4rng-html.xsl) via Maven 'mvn clean install' to add IDs for RelaxNG Defines & HRefs for RelaxNG refs
11. Copy the transformed "*-rng.html" files
    from "ROOT\target\generated-resources\xml\xslt"
    to   "ROOT\docs\odf1.3\csd03" (or correct destination)

**NOTE:**
Original CSS was downloaded from [Chromium sources](https://chromium.googlesource.com/chromium/blink/+/72fef91ac1ef679207f51def8133b336a6f6588f/Source/core/css/view-source.css?autodive=0%2F%2F%2F)