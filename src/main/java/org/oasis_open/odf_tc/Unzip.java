
package org.oasis_open.odf_tc;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class Unzip
{

public static void main(String[] args) throws Exception
{
    if (args.length != 1) {
        System.err.println("Usage: java -cp target/classes org.oasis_open.odf_tc.Unzip foo.odt");
        System.exit(1);
    }

    String filename = args[0];
    String dirname = filename.replaceAll("\\.odt$", "_odt");
    // rm -rf
    try {
        Files.walkFileTree(Paths.get(dirname), new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes __) throws IOException {
                Files.delete(file);
                return FileVisitResult.CONTINUE;
            }
            @Override
            public FileVisitResult postVisitDirectory(Path dir, IOException __) throws IOException {
                Files.delete(dir);
                return FileVisitResult.CONTINUE;
            }
        });
    } catch (NoSuchFileException __) {
        /* ignore if dirname doesn't exist */
    }
    // read zipfile
    FileInputStream f = new FileInputStream(filename);
    BufferedInputStream bis = new BufferedInputStream(f);
    ZipInputStream zip = new ZipInputStream(bis /*, UTF-8 is default */);
    ZipEntry entry;
    while ((entry = zip.getNextEntry()) != null) {
        String file = entry.getName();
        Path p = Paths.get(dirname, file);
        if (entry.isDirectory()) {
            Files.createDirectories(p);
        } else {
            Files.createDirectories(p.getParent());
            OutputStream out = new BufferedOutputStream(
                Files.newOutputStream(p, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE));
            // not sure why entry.getSize() is always -1 here
            int b;
            while ((b = zip.read()) != -1) {
                out.write(b);
            }
            out.close();
        }
        zip.closeEntry();
    }
    zip.close(); // closes f as well
}

}
