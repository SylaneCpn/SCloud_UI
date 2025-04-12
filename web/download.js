async function saveFile(url , name) {
    try {
      // create a new handle
      const newHandle = await window.showSaveFilePicker({"suggestedName" : name });
  
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

        catch(_) {
            return "network_fail"
        }
  
      
    } catch (_) {
      return "cancelled";
    }
  }