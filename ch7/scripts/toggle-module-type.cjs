// scripts/toggle-module-type.js

const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(__dirname, '..', 'package.json');
const pkg = JSON.parse(fs.readFileSync(packageJsonPath, 'utf-8'));

if (pkg.type === 'module') {
  delete pkg.type;
  console.log('🔧 Removed "type": "module" from package.json');
} else {
  pkg.type = 'module';
  console.log('🔧 Added "type": "module" to package.json');
}

fs.writeFileSync(packageJsonPath, JSON.stringify(pkg, null, 2));
