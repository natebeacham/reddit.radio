express = require 'express'

app = express()

app.get '/', (req, res) -> 
	res.sendfile 'templates/index.html'

app.use '/media', express.static 'media'

app.listen 8001