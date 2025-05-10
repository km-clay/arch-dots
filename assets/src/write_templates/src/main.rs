use std::{fs, path::PathBuf};

use regex::Regex;
use serde::Deserialize;

#[derive(Deserialize,Debug)]
struct Template {
	path: PathBuf,
	content: String,
}

impl Template {
	pub fn interpolate(&self, regex: &Regex, colors: &Colors) -> String {
		regex.replace_all(&self.content, |caps: &regex::Captures| {
			let key = &caps[1];
			colors.get_color(key).unwrap()
		}).into_owned()
	}
}

#[derive(Deserialize,Debug)]
struct Colors {
	base00: String,
	base01: String,
	base02: String,
	base03: String,
	base04: String,
	base05: String,
	base06: String,
	base07: String,
	base08: String,
	base09: String,
	base0a: String,
	base0b: String,
	base0c: String,
	base0d: String,
	base0e: String,
	base0f: String,
}

impl Colors {
	pub fn get_color(&self, name: &str) -> Option<&str> {
		match name.to_lowercase().as_str() {
			"base00" | "bg"                  => Some(&self.base00),
			"base01" | "bg_alt"              => Some(&self.base01),
			"base02" | "selection"           => Some(&self.base02),
			"base03" | "comment"             => Some(&self.base03),
			"base04" | "fg_alt"              => Some(&self.base04),
			"base05" | "fg"                  => Some(&self.base05),
			"base06" | "fg_light"            => Some(&self.base06),
			"base07" | "fg_dim"              => Some(&self.base07),
			"base08" | "error" | "red"       => Some(&self.base08),
			"base09" | "const" | "orange"    => Some(&self.base09),
			"base0a" | "label" | "yellow"    => Some(&self.base0a),
			"base0b" | "string" | "green"    => Some(&self.base0b),
			"base0c" | "class" | "cyan"      => Some(&self.base0c),
			"base0d" | "func" | "blue"       => Some(&self.base0d),
			"base0e" | "keyword" | "magenta" => Some(&self.base0e),
			"base0f" | "special" | "warning" => Some(&self.base0f),
			_ => None
		}
	}
}

fn main() {
	let repl_pattern = Regex::new(r"\$\{\{([a-zA-Z0-9_]+)\}\}").unwrap();
	let colors_raw = fs::read_to_string("/home/pagedmov/dotfiles/assets/ogsteam.toml").unwrap();
	let colors: Colors = toml::from_str(&colors_raw).unwrap();
	let paths = fs::read_dir("/home/pagedmov/dotfiles/templates").unwrap();
	for path in paths {
		let template_raw = fs::read_to_string(path.unwrap().path()).unwrap();
		let template: Template = toml::from_str(&template_raw).unwrap();
		let output = template.interpolate(&repl_pattern, &colors);
		//println!("{output}");
		fs::write(template.path, output).unwrap();
	}
}
