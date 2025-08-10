import std.stdio;
import std.range;
import std.algorithm;
import std.string;
import std.regex;
import std.file;
import std.datetime;
import std.getopt;
import std.json;
import std.path;
import std.format;
import std.process : environment;
import std.conv;

alias fileWrite = std.file.write;

// Sistema de Internacionalização
enum Language : string
{
	PT_BR = "pt_BR",
	EN_US = "en_US"
}

struct Messages
{
	// Mensagens de erro
	string ADD_COMMAND_ERROR_ARG;
	string ADD_COMMAND_INVALID_ARG;
	string ADD_COMMAND_SUCCESS;
	string COMPLETE_COMMAND_ERROR_ARG;
	string REMOVE_COMMAND_ERROR_ARG;
	string EDIT_COMMAND_ERROR_ARG;
	string SEARCH_COMMAND_ERROR_ARG;
	string TASK_NOT_FOUND;
	string TASK_REMOVED_SUCCESS;
	string TASK_UPDATED_SUCCESS;
	string NO_CHANGES_MADE;
	string ERROR_SEARCHING_TASK;
	string ERROR_REMOVING_TASK;
	string ERROR_EDITING_TASK;
	string ERROR_COMPLETING_TASK;
	string ERROR_LISTING_TASKS;
	string ERROR_ADDING_TASK;
	string UNKNOWN_PRIORITY;
	string UNKNOWN_STATUS;
	string UNKNOWN_COMMAND;
	string NO_WINDOWS_SUPPORT;
	string CREATING_MAIN_DIR;
	string CREATING_MAIN_FILE;

	// Mensagens da interface
	string TOTAL_TASKS;
	string PENDING_TASKS;
	string COMPLETED_TASKS;
	string HELP_HEADER;
	string HELP_COMMANDS;
	string HELP_FLAGS;

	// Headers da tabela
	string HEADER_ID;
	string HEADER_TITLE;
	string HEADER_STATUS;
	string HEADER_PRIORITY;
	string HEADER_CREATED;
	string HEADER_DUE;

	// Status e prioridades
	string STATUS_PENDING;
	string STATUS_COMPLETE;
	string STATUS_FAILED;
	string PRIORITY_LOW;
	string PRIORITY_MEDIUM;
	string PRIORITY_HIGH;
}

class I18n
{
private:
	Language currentLanguage;
	Messages messages;
	string configFile;

	void loadPortugueseMessages()
	{
		messages.ADD_COMMAND_ERROR_ARG = "O comando espera 1 argumento.\nEx: todo-cli add \"Nova tarefa\"";
		messages.ADD_COMMAND_INVALID_ARG = "Era esperado uma string como argumento, recebido '%s'.";
		messages.ADD_COMMAND_SUCCESS = "✅ Tarefa #%d adicionada com sucesso!";
		messages.COMPLETE_COMMAND_ERROR_ARG = "O comando espera 1 argumento.\nEx: todo-cli complete 1";
		messages.REMOVE_COMMAND_ERROR_ARG = "O comando espera 1 argumento.\nEx: todo-cli remove 1";
		messages.EDIT_COMMAND_ERROR_ARG = "O comando espera 1 argumento.\nEx: todo-cli edit 1 --title \"Novo Titulo\"";
		messages.SEARCH_COMMAND_ERROR_ARG = "O comando espera 1 argumento.\nEx: todo-cli search \"titulo ou palavra chave\"";
		messages.TASK_NOT_FOUND = "Task com ID %s não encontrada!";
		messages.TASK_REMOVED_SUCCESS = "Task removida com sucesso!";
		messages.TASK_UPDATED_SUCCESS = "Task atualizada com sucesso!";
		messages.NO_CHANGES_MADE = "Nenhuma alteração foi feita.";
		messages.ERROR_SEARCHING_TASK = "Ocorreu um erro ao buscar a task pelo id: %s";
		messages.ERROR_REMOVING_TASK = "Ocorreu um erro ao remover a task: %s";
		messages.ERROR_EDITING_TASK = "Ocorreu um erro ao editar a task: %s";
		messages.ERROR_COMPLETING_TASK = "Ocorreu um erro ao completar a task: %s";
		messages.ERROR_LISTING_TASKS = "Ocorreu um erro ao listar as tasks: %s";
		messages.ERROR_ADDING_TASK = "Ocorreu um erro ao adicionar a task: %s";
		messages.UNKNOWN_PRIORITY = "Prioridade desconhecida '%s'.";
		messages.UNKNOWN_STATUS = "Status desconhecido '%s'.";
		messages.UNKNOWN_COMMAND = "Comando desconhecido '%s', veja os comandos usando 'help'";
		messages.NO_WINDOWS_SUPPORT = "Não há suporte para o windows no momento.";
		messages.CREATING_MAIN_DIR = "Criando diretório principal %s";
		messages.CREATING_MAIN_FILE = "Criando arquivo principal %s";
		messages.TOTAL_TASKS = "📊 Total: %d tarefas | %d pendentes | %d concluídas";
		messages.PENDING_TASKS = "pendentes";
		messages.COMPLETED_TASKS = "concluídas";
		messages.HELP_HEADER = "Todo CLI - v%s";
		messages.HELP_COMMANDS = "Comandos disponiveis:\n  add\t\t- Adiciona uma nova tarefa\n  list\t\t- Lista as tarefas\n  complete\t- Completa uma tarefa\n  remove\t- Remove uma tarefa\n  edit\t\t- Edita uma tarefa\n  search\t- Pesquisa por uma tarefa\n  lang\t\t- Configura o idioma";
		messages.HELP_FLAGS = "Flags disponiveis:\n  due|D\t\t- Seta a data final\n  priority|P\t- Seta a prioridade (low, medium, high)\n  days|d\t- Seta a quantidade de dias para a data final\n  hours|h\t- Seta a quantidade de horas para a data final\n  title|T\t- Seta um novo titulo para a task\n  FP\t\t- Filtra por prioridade (low, medium, high)\n  FS\t\t- Filtra por status (pending, complete)";
		messages.HEADER_ID = "ID";
		messages.HEADER_TITLE = "Título";
		messages.HEADER_STATUS = "Status";
		messages.HEADER_PRIORITY = "Prioridade";
		messages.HEADER_CREATED = "Criado";
		messages.HEADER_DUE = "Vencimento";
		messages.STATUS_PENDING = "pendente";
		messages.STATUS_COMPLETE = "completo";
		messages.STATUS_FAILED = "falhou";
		messages.PRIORITY_LOW = "baixa";
		messages.PRIORITY_MEDIUM = "média";
		messages.PRIORITY_HIGH = "alta";
	}

	void loadEnglishMessages()
	{
		messages.ADD_COMMAND_ERROR_ARG = "Command expects 1 argument.\nEx: todo-cli add \"New task\"";
		messages.ADD_COMMAND_INVALID_ARG = "Expected string as argument, received '%s'.";
		messages.ADD_COMMAND_SUCCESS = "✅ Task #%d added successfully!";
		messages.COMPLETE_COMMAND_ERROR_ARG = "Command expects 1 argument.\nEx: todo-cli complete 1";
		messages.REMOVE_COMMAND_ERROR_ARG = "Command expects 1 argument.\nEx: todo-cli remove 1";
		messages.EDIT_COMMAND_ERROR_ARG = "Command expects 1 argument.\nEx: todo-cli edit 1 --title \"New Title\"";
		messages.SEARCH_COMMAND_ERROR_ARG = "Command expects 1 argument.\nEx: todo-cli search \"title or keyword\"";
		messages.TASK_NOT_FOUND = "Task with ID %s not found!";
		messages.TASK_REMOVED_SUCCESS = "Task removed successfully!";
		messages.TASK_UPDATED_SUCCESS = "Task updated successfully!";
		messages.NO_CHANGES_MADE = "No changes were made.";
		messages.ERROR_SEARCHING_TASK = "An error occurred while searching for task by id: %s";
		messages.ERROR_REMOVING_TASK = "An error occurred while removing task: %s";
		messages.ERROR_EDITING_TASK = "An error occurred while editing task: %s";
		messages.ERROR_COMPLETING_TASK = "An error occurred while completing task: %s";
		messages.ERROR_LISTING_TASKS = "An error occurred while listing tasks: %s";
		messages.ERROR_ADDING_TASK = "An error occurred while adding task: %s";
		messages.UNKNOWN_PRIORITY = "Unknown priority '%s'.";
		messages.UNKNOWN_STATUS = "Unknown status '%s'.";
		messages.UNKNOWN_COMMAND = "Unknown command '%s', see commands using 'help'";
		messages.NO_WINDOWS_SUPPORT = "Windows support is not available at the moment.";
		messages.CREATING_MAIN_DIR = "Creating main directory %s";
		messages.CREATING_MAIN_FILE = "Creating main file %s";
		messages.TOTAL_TASKS = "📊 Total: %d tasks | %d pending | %d completed";
		messages.PENDING_TASKS = "pending";
		messages.COMPLETED_TASKS = "completed";
		messages.HELP_HEADER = "Todo CLI - v%s";
		messages.HELP_COMMANDS = "Available commands:\n  add\t\t- Add a new task\n  list\t\t- List tasks\n  complete\t- Complete a task\n  remove\t- Remove a task\n  edit\t\t- Edit a task\n  search\t- Search for a task\n  lang\t\t- Configure language";
		messages.HELP_FLAGS = "Available flags:\n  due|D\t\t- Set due date\n  priority|P\t- Set priority (low, medium, high)\n  days|d\t- Set days for due date\n  hours|h\t- Set hours for due date\n  title|T\t- Set new title for task\n  FP\t\t- Filter by priority (low, medium, high)\n  FS\t\t- Filter by status (pending, complete)";
		messages.HEADER_ID = "ID";
		messages.HEADER_TITLE = "Title";
		messages.HEADER_STATUS = "Status";
		messages.HEADER_PRIORITY = "Priority";
		messages.HEADER_CREATED = "Created";
		messages.HEADER_DUE = "Due";
		messages.STATUS_PENDING = "pending";
		messages.STATUS_COMPLETE = "complete";
		messages.STATUS_FAILED = "failed";
		messages.PRIORITY_LOW = "low";
		messages.PRIORITY_MEDIUM = "medium";
		messages.PRIORITY_HIGH = "high";
	}

	Language detectSystemLanguage()
	{
		string lang = environment.get("LANG", "");
		string lc_all = environment.get("LC_ALL", "");
		string lc_messages = environment.get("LC_MESSAGES", "");

		// Prioridade: LC_ALL > LC_MESSAGES > LANG
		string systemLang = lc_all != "" ? lc_all : (lc_messages != "" ? lc_messages : lang);

		if (systemLang.startsWith("pt_BR") || systemLang.startsWith("pt"))
		{
			return Language.PT_BR;
		}

		return Language.EN_US;
	}

	void saveConfig()
	{
		JSONValue config;
		config["language"] = cast(string) currentLanguage;

		try
		{
			fileWrite(configFile, config.toPrettyString());
		}
		catch (Exception e)
		{
			// Silently ignore config save errors
		}
	}

	void loadConfig()
	{
		try
		{
			if (exists(configFile))
			{
				string content = readText(configFile);
				JSONValue config = parseJSON(content);
				string langStr = config["language"].str;

				if (langStr == Language.PT_BR || langStr == Language.EN_US)
				{
					currentLanguage = cast(Language) langStr;
					return;
				}
			}
		}
		catch (Exception e)
		{
			// Ignore config load errors and use system detection
		}

		// Fallback to system detection
		currentLanguage = detectSystemLanguage();
		saveConfig();
	}

public:
	this(string mainDir)
	{
		configFile = buildPath(mainDir, "config.json");
		loadConfig();
		// setLanguage(currentLanguage);
	}

	void setLanguage(Language lang)
	{
		currentLanguage = lang;

		if (lang == Language.PT_BR)
		{
			loadPortugueseMessages();
		}
		else
		{
			loadEnglishMessages();
		}

		saveConfig();
	}

	Language getCurrentLanguage()
	{
		return currentLanguage;
	}

	Messages getMessages()
	{
		return messages;
	}

	void handleLanguageCommand(string[] args)
	{
		if (args.length == 0)
		{
			// Mostrar idioma atual
			string currentLangName = (currentLanguage == Language.PT_BR) ? "Português (Brasil)"
				: "English (US)";
			if (currentLanguage == Language.PT_BR)
			{
				writeln("Idioma atual: " ~ currentLangName);
				writeln("Idiomas disponíveis: pt_BR, en_US");
				writeln("Use: todo-cli lang <código_idioma>");
			}
			else
			{
				writeln("Current language: " ~ currentLangName);
				writeln("Available languages: pt_BR, en_US");
				writeln("Use: todo-cli lang <language_code>");
			}
			return;
		}

		string newLang = args[0];

		if (newLang == "pt_BR" || newLang == "pt")
		{
			setLanguage(Language.PT_BR);
			writeln("✅ Idioma alterado para Português (Brasil)");
		}
		else if (newLang == "en_US" || newLang == "en")
		{
			setLanguage(Language.EN_US);
			writeln("✅ Language changed to English (US)");
		}
		else
		{
			if (currentLanguage == Language.PT_BR)
			{
				writeln("❌ Idioma desconhecido: " ~ newLang);
				writeln("Idiomas disponíveis: pt_BR, en_US");
			}
			else
			{
				writeln("❌ Unknown language: " ~ newLang);
				writeln("Available languages: pt_BR, en_US");
			}
		}
	}
}

// Instância global do sistema de i18n
I18n i18n;

// Versão do script
const string VERSION = "0.1.0";

// Constantes globais para uso em qualquer local do script
string HOME, MAIN_DIR, MAIN_FILE;

// [Resto do código permanece igual, mas usando i18n.getMessages() para acessar as mensagens]

// Formatador ConsoleTable (mesmo código)
class ConsoleTable
{
private:
	string[] headers;
	string[][] rows;
	int[size_t] columnWidths;

	string stripAnsiCodes(string text)
	{
		string result = "";
		bool inEscape = false;

		for (size_t i = 0; i < text.length; i++)
		{
			if (text[i] == '\033' && i + 1 < text.length && text[i + 1] == '[')
			{
				inEscape = true;
				i++;
				continue;
			}

			if (inEscape)
			{
				if (text[i] == 'm')
				{
					inEscape = false;
				}
				continue;
			}

			result ~= text[i];
		}

		return result;
	}

	string strRepeat(string str, int times)
	{
		string buff;
		for (size_t i; i < times; i++)
			buff ~= str;
		return buff;
	}

	void calculateColumnWidths(string[] row)
	{
		foreach (size_t key, string cell; row)
		{
			int cellLength = cast(int) stripAnsiCodes(cell).length;
			if (key !in this.columnWidths || cellLength > this.columnWidths[key])
			{
				this.columnWidths[key] = cellLength;
			}
		}
	}

	void printLine()
	{
		string line = "+";
		foreach (width; this.columnWidths.byValue())
		{
			line ~= strRepeat("-", width + 2) ~ "+";
		}
		writeln(line);
	}

	void printRow(string[] row)
	{
		string line = "|";
		foreach (size_t key, string cell; row)
		{
			if (key in this.columnWidths)
			{
				int visualLength = cast(int) stripAnsiCodes(cell).length;
				int padding = this.columnWidths[key] - visualLength;
				line ~= " " ~ cell ~ strRepeat(" ", padding) ~ " |";
			}
		}
		writeln(line);
	}

public:
	void setHeaders(string[] headers)
	{
		this.headers = headers;
		this.calculateColumnWidths(headers);
	}

	void addRow(string[] row)
	{
		this.rows ~= row;
		this.calculateColumnWidths(row);
	}

	void render()
	{
		this.printLine();
		this.printRow(this.headers);
		this.printLine();
		foreach (row; this.rows)
		{
			this.printRow(row);
		}
		this.printLine();
	}
}

enum Color : string
{
	RESET = "\033[0m",
	BLACK = "\033[30m",
	RED = "\033[31m",
	GREEN = "\033[32m",
	YELLOW = "\033[33m",
	BLUE = "\033[34m",
	MAGENTA = "\033[35m",
	CYAN = "\033[36m",
	WHITE = "\033[37m",
	BRIGHT_BLACK = "\033[90m",
	BRIGHT_RED = "\033[91m",
	BRIGHT_GREEN = "\033[92m",
	BRIGHT_YELLOW = "\033[93m",
	BRIGHT_BLUE = "\033[94m",
	BRIGHT_MAGENTA = "\033[95m",
	BRIGHT_CYAN = "\033[96m",
	BRIGHT_WHITE = "\033[97m"
}

enum TextStyle : string
{
	RESET = "\033[0m",
	BOLD = "\033[1m",
	DIM = "\033[2m",
	ITALIC = "\033[3m",
	UNDERLINE = "\033[4m"
}

string colorize(string text, Color color)
{
	return color ~ text ~ Color.RESET;
}

string stylize(string text, TextStyle style)
{
	return style ~ text ~ TextStyle.RESET;
}

string boldRed(string text)
{
	return Color.RED ~ TextStyle.BOLD ~ text ~ TextStyle.RESET;
}

string boldGreen(string text)
{
	return Color.GREEN ~ TextStyle.BOLD ~ text ~ TextStyle.RESET;
}

string boldYellow(string text)
{
	return Color.YELLOW ~ TextStyle.BOLD ~ text ~ TextStyle.RESET;
}

string boldBlue(string text)
{
	return Color.BLUE ~ TextStyle.BOLD ~ text ~ TextStyle.RESET;
}

string bold(string text)
{
	return stylize(text, TextStyle.BOLD);
}

string italic(string text)
{
	return stylize(text, TextStyle.ITALIC);
}

enum Priority : string
{
	LOW = "low",
	MEDIUM = "medium",
	HIGH = "high"
}

enum Status : string
{
	PENDING = "pending",
	COMPLETE = "complete",
	FAILED = "failed"
}

struct Task
{
	long id;
	string title;
	Status status;
	Priority priority;
	string due;
	string created_at;

	this(long id, Priority priority, Status status, string title, string due, string created_at)
	{
		this.id = id;
		this.title = title;
		this.status = status;
		this.priority = priority;
		this.due = due;
		this.created_at = created_at;
	}
}

JSONValue taskToJson(ref Task t)
{
	JSONValue obj;
	obj["id"] = t.id;
	obj["title"] = t.title;
	obj["status"] = t.status;
	obj["priority"] = t.priority;
	obj["due"] = t.due;
	obj["created_at"] = t.created_at;
	return obj;
}

string getColoredStatus(string status)
{
	auto messages = i18n.getMessages();
	string displayStatus = status;

	switch (status)
	{
	case "pending":
		displayStatus = messages.STATUS_PENDING;
		return boldYellow(displayStatus);
	case "complete":
		displayStatus = messages.STATUS_COMPLETE;
		return boldGreen(displayStatus);
	case "failed":
		displayStatus = messages.STATUS_FAILED;
		return boldRed(displayStatus);
	default:
		return bold(displayStatus);
	}
}

string getColoredPriority(string priority)
{
	auto messages = i18n.getMessages();
	string displayPriority = priority;

	switch (priority)
	{
	case "low":
		displayPriority = messages.PRIORITY_LOW;
		return boldGreen(displayPriority);
	case "medium":
		displayPriority = messages.PRIORITY_MEDIUM;
		return boldYellow(displayPriority);
	case "high":
		displayPriority = messages.PRIORITY_HIGH;
		return boldRed(displayPriority);
	default:
		return bold(displayPriority);
	}
}

long findTaskById(ref JSONValue data, long id, ref bool found)
{
	try
	{
		auto tasksArray = data["tasks"].array;
		foreach (size_t index, JSONValue task; tasksArray)
		{
			if (task["id"].integer == id)
			{
				found = true;
				return cast(long) index;
			}
		}
	}
	catch (Exception e)
	{
		auto messages = i18n.getMessages();
		writeln(bold(format(messages.ERROR_SEARCHING_TASK, e.msg)));
	}
	return -1;
}

void removeCommand(string[] args)
{
	auto messages = i18n.getMessages();

	if (args.length != 1)
	{
		writeln(messages.REMOVE_COMMAND_ERROR_ARG);
		return;
	}

	try
	{
		auto arg = args[0];
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		auto tasks = data["tasks"].array.dup;
		bool found = false;
		long index = findTaskById(data, to!long(arg), found);

		if (!found)
		{
			writeln(format(messages.TASK_NOT_FOUND, arg));
			return;
		}

		auto newTasks = tasks[0 .. index] ~ tasks[index + 1 .. $];
		data["tasks"] = JSONValue(newTasks);

		fileWrite(MAIN_FILE, data.toPrettyString());
		writeln(messages.TASK_REMOVED_SUCCESS);
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_REMOVING_TASK, e.msg)));
		return;
	}
}

void editCommand(string[] args, string title, string priority)
{
	auto messages = i18n.getMessages();

	if (args.length != 1)
	{
		writeln(messages.EDIT_COMMAND_ERROR_ARG);
		return;
	}

	if (title == "")
	{
		writeln(messages.NO_CHANGES_MADE);
		return;
	}

	try
	{
		auto arg = args[0];
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		bool found = false;
		long index = findTaskById(data, to!long(arg), found);

		if (!found)
		{
			writeln(format(messages.TASK_NOT_FOUND, arg));
			return;
		}

		data["tasks"][index]["title"] = JSONValue(title);
		fileWrite(MAIN_FILE, data.toPrettyString());
		writeln(messages.TASK_UPDATED_SUCCESS);
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_EDITING_TASK, e.msg)));
		return;
	}
}

void searchCommand(string[] args, string filterPriority = "", string filterStatus = "")
{
	auto messages = i18n.getMessages();

	if (args.length != 1)
	{
		writeln(messages.SEARCH_COMMAND_ERROR_ARG);
		return;
	}

	try
	{
		auto arg = args[0];
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		auto table = new ConsoleTable();
		table.setHeaders([
			messages.HEADER_ID,
			messages.HEADER_TITLE,
			messages.HEADER_STATUS,
			messages.HEADER_PRIORITY,
			messages.HEADER_CREATED,
			messages.HEADER_DUE
		]);

		int lines;
		int pendentes, concluidas;

		foreach (task; data["tasks"].array)
		{
			if (!canFind(toLower(task["title"].str), toLower(arg)))
				continue;

			string status = task["status"].str;
			if (status == "pending")
				pendentes++;
			else
				concluidas++;

			string priority = task["priority"].str;
			if (filterPriority != "" && priority != filterPriority)
				continue;

			if (filterStatus != "" && status != filterStatus)
				continue;

			table.addRow([
				task["id"].toString(),
				task["title"].str,
				getColoredStatus(status),
				getColoredPriority(priority),
				italic(task["created_at"].str),
				italic(task["due"].str)
			]);
			lines++;
		}

		if (lines > 0)
			table.render();
		writeln(format(messages.TOTAL_TASKS, pendentes + concluidas, pendentes, concluidas));
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_SEARCHING_TASK, e.msg)));
		return;
	}
}

void completeCommand(string[] args)
{
	auto messages = i18n.getMessages();

	if (args.length != 1)
	{
		writeln(messages.COMPLETE_COMMAND_ERROR_ARG);
		return;
	}

	try
	{
		auto arg = args[0];
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		bool found = false;
		long index = findTaskById(data, to!long(arg), found);

		if (!found)
		{
			writeln(format(messages.TASK_NOT_FOUND, arg));
			return;
		}

		data["tasks"][index]["status"] = JSONValue("complete");
		fileWrite(MAIN_FILE, data.toPrettyString());
		writeln(messages.TASK_UPDATED_SUCCESS);
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_COMPLETING_TASK, e.msg)));
		return;
	}
}

void listCommand(string filterPriority = "", string filterStatus = "")
{
	auto messages = i18n.getMessages();

	try
	{
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		auto table = new ConsoleTable();
		table.setHeaders([
			messages.HEADER_ID,
			messages.HEADER_TITLE,
			messages.HEADER_STATUS,
			messages.HEADER_PRIORITY,
			messages.HEADER_CREATED,
			messages.HEADER_DUE
		]);

		int lines;
		int pendentes, concluidas;

		foreach (task; data["tasks"].array)
		{
			string status = task["status"].str;
			if (status == "pending")
				pendentes++;
			else
				concluidas++;

			string priority = task["priority"].str;
			if (filterPriority != "" && priority != filterPriority)
				continue;

			if (filterStatus != "" && status != filterStatus)
				continue;

			table.addRow([
				task["id"].toString(),
				task["title"].str,
				getColoredStatus(status),
				getColoredPriority(priority),
				italic(task["created_at"].str),
				italic(task["due"].str)
			]);
			lines++;
		}

		if (lines > 0)
			table.render();
		writeln(format(messages.TOTAL_TASKS, pendentes + concluidas, pendentes, concluidas));
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_LISTING_TASKS, e.msg)));
		return;
	}
}

void addCommand(string[] args, string due, string priority)
{
	auto messages = i18n.getMessages();

	if (args.length != 1)
	{
		writeln(messages.ADD_COMMAND_ERROR_ARG);
		return;
	}

	try
	{
		auto arg = args[0];
		string file = readText(MAIN_FILE);
		JSONValue data = parseJSON(file);

		long id = data["next_id"].integer;
		data.object["next_id"] = id + 1;

		Task task = Task(id, cast(Priority) priority, Status.PENDING, arg, due, timeToString(
				Clock.currTime()));
		data.object["tasks"] = data["tasks"].array ~ [taskToJson(task)];
		fileWrite(MAIN_FILE, data.toString());

		writeln(format(messages.ADD_COMMAND_SUCCESS, id));
	}
	catch (Exception e)
	{
		writeln(bold(format(messages.ERROR_ADDING_TASK, e.msg)));
		return;
	}
}

void showHelp()
{
	auto messages = i18n.getMessages();

	writeln(format(messages.HELP_HEADER, VERSION));
	writeln("");
	writeln(messages.HELP_COMMANDS);
	writeln("");
	writeln(messages.HELP_FLAGS);
}

void makeMainFile()
{
	auto messages = i18n.getMessages();
	writeln(format(messages.CREATING_MAIN_FILE, MAIN_FILE));
	fileWrite(MAIN_FILE, "{ \"tasks\": [], \"next_id\": 1 }");
}

string timeToString(SysTime timeDefault)
{
	return format("%02d/%02d/%04d %02d:%02d:%02d",
		timeDefault.day, timeDefault.month, timeDefault.year,
		timeDefault.hour, timeDefault.minute, timeDefault.second
	);
}

void main(string[] args)
{
	version (Posix)
	{
		HOME = environment.get("HOME");
		MAIN_DIR = HOME ~ "/.todo-cli/";
		MAIN_FILE = HOME ~ "/.todo-cli/todo.json";

		if (!exists(MAIN_DIR))
		{
			mkdir(MAIN_DIR);
		}

		i18n = new I18n(MAIN_DIR);
		auto messages = i18n.getMessages();

		if (!exists(MAIN_DIR))
		{
			writeln(format(messages.CREATING_MAIN_DIR, MAIN_DIR));
			mkdir(MAIN_DIR);
		}
		if (!exists(MAIN_FILE))
		{
			makeMainFile();
		}
	}
	else version (Windows)
	{
		HOME = environment.get("USERPROFILE", "");
		MAIN_DIR = HOME ~ "\\.todo-cli\\";
		i18n = new I18n(MAIN_DIR);
		auto messages = i18n.getMessages();

		writeln(messages.NO_WINDOWS_SUPPORT);
		return;
	}

	if (args.length < 2)
	{
		showHelp();
		return;
	}

	string priority = Priority.LOW;
	string title = "";
	int days = 1;
	int hours = 0;
	string filterPriority, filterStatus = "";
	string due;

	try
	{
		getopt(args,
			"due|D", &due,
			"title|T", &title,
			"priority|P", &priority,
			"days", &days,
			"hours", &hours,
			"FP", &filterPriority,
			"FS", &filterStatus,
		);
	}
	catch (Exception e)
	{
		writeln(e.msg);
		return;
	}

	// Validações de flag
	if (priority != "low" && priority != "medium" && priority != "high")
	{
		writeln(format(messages.UNKNOWN_PRIORITY, priority));
		return;
	}
	if (filterStatus != "pending" && filterStatus != "complete" && filterStatus != "")
	{
		writeln(format(messages.UNKNOWN_STATUS, filterStatus));
		return;
	}
	if (filterPriority != "low" && filterPriority != "medium" && filterPriority != "high" && filterPriority != "")
	{
		writeln(format(messages.UNKNOWN_PRIORITY, filterPriority));
		return;
	}
	if (due == "")
	{
		SysTime timeDefault = Clock.currTime() + dur!"days"(days) + dur!"hours"(hours);
		due = timeToString(timeDefault);
	}

	string command = to!string(args[1]);

	switch (command)
	{
	case "help":
		showHelp();
		break;
	case "add":
		addCommand(args[2 .. $], due, priority);
		break;
	case "edit":
		editCommand(args[2 .. $], title, priority);
		break;
	case "complete":
		completeCommand(args[2 .. $]);
		break;
	case "search":
		searchCommand(args[2 .. $], filterPriority, filterStatus);
		break;
	case "remove":
		removeCommand(args[2 .. $]);
		break;
	case "list":
		listCommand(filterPriority, filterStatus);
		break;
	case "lang":
	case "language":
		i18n.handleLanguageCommand(args[2 .. $]);
		break;
	default:
		writeln(format(messages.UNKNOWN_COMMAND, command));
		return;
	}
}
