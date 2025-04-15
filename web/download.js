
async function downloadSupported(url, name) {


  try {
    // create a new handle
    const newHandle = await window.showSaveFilePicker({ "suggestedName": name });

    // create a FileSystemWritableFileStream to write to
    const writableStream = await newHandle.createWritable();

    try {
      const response = await fetch(url);
      if (!response.ok) {
        return "refused";
      }

      const data = await response.arrayBuffer();
      // write our file
      await writableStream.write(data);

      // close the file and write the contents to disk.
      await writableStream.close();
      return "success";
    }

    catch (_) {
      return "network_fail"
    }


  } catch (_) {
    return "cancelled";
  }
}

async function downloadUnsupported(url, name) {

  try {
    var link = document.createElement("a");
    link.download = name;
    link.href = url;
    link.click();
    return "success"
  }

  catch (_) {
    return "fail"
  }

}


async function saveFile(url, name) {
  if (typeof (window.showSaveFilePicker) != "undefined") {

    return await downloadSupported(url, name);

  }

  else {

    return await downloadUnsupported(url, name);

  }
}