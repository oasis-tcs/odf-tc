
package org.oasis_open.odf_tc;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class Zip
{

static void writeFile(ZipOutputStream zip, String dirname, Path file, int method)
    throws Exception
{
    byte[] buf = Files.readAllBytes(file);
    ZipEntry entry = new ZipEntry(Paths.get(dirname).relativize(file).toString());
    if (method == ZipOutputStream.STORED) { // have to provide these for STORED
        CRC32 crc = new CRC32();
        crc.update(buf, 0, buf.length);
        entry.setSize(buf.length);
        entry.setCompressedSize(buf.length);
        entry.setCrc(crc.getValue());
    }
    zip.putNextEntry(entry);
    zip.write(buf, 0, buf.length);
    zip.closeEntry();
}

public static void main(String[] args) throws Exception
{
    if (args.length != 1) {
        System.err.println("Usage: java -cp target/classes org.oasis_open.odf_tc.Zip foo.odt");
        System.exit(1);
    }

    String filename = args[0];
    String dirname = filename.replaceAll("\\.odt$", "_odt");
    // find files
    ArrayList<Path> files = new ArrayList<Path>();
    Files.walk(Paths.get(dirname))
        .filter(Files::isRegularFile)
        .forEach(files::add);
    // write zip file
    FileOutputStream f = new FileOutputStream(filename);
    BufferedOutputStream b = new BufferedOutputStream(f);
    ZipOutputStream zip = new ZipOutputStream(b /*, UTF-8 is default */);
    // mimetype is special
    zip.setMethod(ZipOutputStream.STORED);
    Path mimetype = Paths.get(dirname, "mimetype");
    int i = files.indexOf(mimetype);
    writeFile(zip, dirname, mimetype, ZipOutputStream.STORED);
    files.remove(i);
    zip.setMethod(ZipOutputStream.DEFLATED);
    for (Path file : files) {
        writeFile(zip, dirname, file, ZipOutputStream.DEFLATED);
    }
    zip.close(); // closes f as well
}

}
