const fs=require('fs');const p=process.argv[2];let b=fs.readFileSync(p);console.log(b.toString(b[0]===255?'utf16le':'utf8'));
