import * as fs from 'fs'

export default function fileExistsAndIsNonEmpty(path) {
  try {
    const stat = fs.statSync(path)

    return stat.isFile() && stat.size !== 0
  } catch (e) {
    return false
  }
}
