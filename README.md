# todo-cli

A personal command-line task manager written in D. I built this to solve my own productivity problems and decided to make it public in case it helps someone else.

## Why I Built This

I was frustrated with existing task managers - they were either too bloated with features I don't need, or too simple to handle real workflows. I needed something that could:

- Start instantly without loading screens
- Handle priorities and deadlines properly
- Filter and search tasks efficiently
- Look decent in the terminal
- Stay lightweight and fast

Since I couldn't find exactly what I wanted, I built it myself.

## Current Features

**Basic Operations**
- Add tasks with priorities (low, medium, high) and deadlines
- List all tasks in a formatted table
- Mark tasks as complete
- Edit task titles
- Remove tasks
- Search tasks by title

**Advanced Filtering**
- Filter by priority: `--FP high`
- Filter by status: `--FS pending`
- Chain filters: `--FS pending --FP high`
- Search with filters: `search "project" --FP medium`

**Time Handling**
- Set deadlines in days: `--days 5`
- Set deadlines in hours: `--hours 2`  
- Custom due dates: `--due "15/08/2025"`
- Tasks default to 1 day if no time specified

**Language Support**
- Multi-language interface (Portuguese BR and English US)
- Automatic system language detection
- Persistent language configuration
- Localized error messages, status labels, and help text

**Output**
- Colored output for priorities and status
- Clean ASCII table formatting
- Task statistics at bottom of lists
- Italic formatting for dates

## Language System

The todo-cli automatically detects your system language and switches between Portuguese (Brazil) and English (US) interfaces.

### Automatic Detection
On first run, the application checks your environment variables in this order:
1. `LC_ALL`
2. `LC_MESSAGES` 
3. `LANG`

If any of these contains "pt_BR" or "pt", it defaults to Portuguese. Otherwise, it uses English.

### Manual Language Configuration

```bash
# Check current language
./todo-cli lang

# Switch to Portuguese
./todo-cli lang pt_BR
# or
./todo-cli lang pt

# Switch to English  
./todo-cli lang en_US
# or
./todo-cli lang en
```

### Language Features
- **All interface text** is localized (commands, errors, help, status labels)
- **Persistent settings** - your language choice is saved in `~/.todo-cli/config.json`
- **Contextual help** - help text and examples adapt to your chosen language
- **Status and priority labels** - "pending/pendente", "high/alta", etc.

## Usage Examples

```bash
# Add some tasks
./todo-cli add "Fix production bug" --priority high --hours 2
./todo-cli add "Review documentation" --priority medium --days 3
./todo-cli add "Update dependencies" --priority low --days 7

# List all tasks - shows a clean formatted table
./todo-cli list
```

Output (English):
```
+----+----------------------+----------+----------+---------------------+---------------------+
| ID | Title                | Status   | Priority | Created             | Due                 |
+----+----------------------+----------+----------+---------------------+---------------------+
| 1  | Fix production bug   | pending  | high     | 10/08/2025 14:30:15 | 10/08/2025 16:30:15 |
| 2  | Review documentation | pending  | medium   | 10/08/2025 14:31:02 | 13/08/2025 14:31:02 |
| 3  | Update dependencies  | complete | low      | 10/08/2025 14:31:20 | 17/08/2025 14:31:20 |
+----+----------------------+----------+----------+---------------------+---------------------+
📊 Total: 3 tasks | 2 pending | 1 completed
```

Output (Portuguese):
```
+----+----------------------+-----------+-----------+---------------------+---------------------+
| ID | Título               | Status    | Prioridade| Criado              | Vencimento          |
+----+----------------------+-----------+-----------+---------------------+---------------------+
| 1  | Fix production bug   | pendente  | alta      | 10/08/2025 14:30:15 | 10/08/2025 16:30:15 |
| 2  | Review documentation | pendente  | média     | 10/08/2025 14:31:02 | 13/08/2025 14:31:02 |
| 3  | Update dependencies  | completo  | baixa     | 10/08/2025 14:31:20 | 17/08/2025 14:31:20 |
+----+----------------------+-----------+-----------+---------------------+---------------------+
📊 Total: 3 tarefas | 2 pendentes | 1 concluídas
```

More examples:
```bash
# Filter by status
./todo-cli list --FS pending

# Search with filters
./todo-cli search "project" --FP high

# Mark task as complete
./todo-cli complete 1

# Edit task title
./todo-cli edit 2 --title "Updated task name"

# Get help in your language
./todo-cli help
```

## Data Storage

Tasks are stored in `~/.todo-cli/todo.json` as JSON. Language preferences are saved in `~/.todo-cli/config.json`. Both files are simple and portable.

## Caveats & Limitations

I'm not a professional D developer - this is a learning project that grew into something useful. The code probably has some inefficiencies and patterns that experienced D developers would handle differently. I've focused on making it work reliably for my needs rather than perfect optimization.

Some things I know could be better:
- Error handling could be more graceful in edge cases
- Performance might not be optimal for very large task lists
- Code organization could probably be cleaner
- Memory usage isn't optimized
- Only two languages supported (but easy to extend)

That said, it works well for my daily use with hundreds of tasks.

## Platform Support

Linux/Unix only. I don't use Windows and won't be adding support for it.

## Future Plans

I'll continue adding features as I need them for my own workflow:
- Statistics and analytics
- Better time tracking
- Project organization
- Recurring tasks
- Export functionality
- Additional language support (Spanish, French, etc.)

## Contributing

This is primarily built for my personal use, but if you find it useful:
- Bug fixes are welcome
- Performance improvements are appreciated
- Feature requests should align with keeping it simple and fast
- **Language translations** are especially welcome - the i18n system makes adding new languages straightforward
- Please keep code readable and well-commented

### Adding New Languages

If you want to contribute a translation:
1. Add your language enum to the `Language` enum
2. Create a `loadYourLanguageMessages()` method in the `I18n` class
3. Add detection logic to `detectSystemLanguage()` 
4. Update the language switching logic in `handleLanguageCommand()`

The messages struct contains all user-facing strings, making translation straightforward.

---

A personal tool that happened to work well enough to share.
