stackexchange = require("stackexchange")
context = new stackexchange { version: 2.2 }

module.exports = (robot) ->
	robot.respond /how do i (.*)/i, (msg) ->
		query = {
			q: msg.match[1],
			answers: 1,
			site: "stackoverflow"
		}

		context.search.advanced(query, (err, results) ->
			ids = []
			try
				for item in results.items when item.is_answered
					do (item) ->
						ids.push item.accepted_answer_id if item.accepted_answer_id?
			catch error
				""
			finally
				""
			context.answers.answers({filter: "!9YdnSMldD"}, (err, results) ->
				answer = results.items[0]
				user = answer.owner.display_name

				answer_text = answer.body.replace(/<pre><code>|<\/code><\/pre>/ig, "```")
					.replace(/<[^>]*>/ig, "")

				answer_split = answer_text.split("```")

				for part in [0...answer_split.length] by 2
					answer_split[part] = answer_split[part].replace(/\r?\n|\r/g,"\n>")

				answer_text = answer_split.join("```")

				message = "'#{user}' said: \n" + answer_text

				msg.send message
			, ids)
		)

