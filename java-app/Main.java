import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

class Main {
  public static void main(String[] args) throws IOException {
    String dockerFileContent = "FROM alpine:latest\nVOLUME /tmp\nCMD [\"sh\", \"-c\", \"echo 'Hello World' /tmp/dest_file\"]";
    File file = new File("Dockerfile");
    if(!file.exists()) {
      file.createNewFile();
    }

    try(FileWriter writer = new FileWriter(file)) {
      writer.write(dockerFileContent)
    }

    String buildCommand = "docker build -t test-image .";
    String runCommand = "docker run --rm -v /tmp:/tmp test-image:latest";

    new ProcessBuilder(buildCommand).start();
    new ProcessBuilder(runCommand).start();
  }
}
