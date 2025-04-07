\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{my_homework}[2023/09/24 Class file for homework assignments]

% ----- Options ---------------------------------------------------------------
\DeclareOption{newpage}{}

\DeclareOption{10pt}{\def\mt@ptsize{10pt}
\def\my@marginsize{1.4in}}
\DeclareOption{11pt}{\def\my@ptsize{11pt}
\def\my@marginsize{1.2in}}
\DeclareOption{12pt}{\def\my@ptsize{12pt}
\def\my@marginsize{1in}}

\ExecuteOptions{11pt}
\PassOptionsToClass{\my@ptsize}{article}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% ----- Packages --------------------------------------------------------------

% LaTeX3e features
\RequirePackage{xparse}
\RequirePackage{etoolbox}
\RequirePackage{xstring}

% Empty argument checker
\RequirePackage{ifmtarg}

% Better page geometry
\RequirePackage[letterpaper, margin=\my@marginsize]{geometry}

% Accerate date for Nix
\RequirePackage{filemod}

% Header
\RequirePackage{fancyhdr}

% Font sizing
\RequirePackage{relsize}

% Nice lists
\RequirePackage{enumerate}
\RequirePackage{enumitem}

% Math packages
\usepackage{amsmath}
\usepackage{mathtools}
\usepackage{amsfonts}
\usepackage{amssymb}
\usepackage[scr=rsfs]{mathalpha}

% Tikz
\usepackage{tikz}
\usetikzlibrary{cd}

% Links/refs
\usepackage{hyperref}
\AtEndPreamble{\usepackage[capitalise, nameinlink, noabbrev]{cleveref}}

% Better tables
\usepackage{booktabs}



% ----- Questions -------------------------------------------------------------
\newcounter{problemCounter}
\setcounter{problemCounter}{1}

% Prefix for questions
\newcommand{\questiontype}[0]{Problem}

\NewDocumentCommand{\problem}{o o}{
  \@ifclasswith{my_homework}{newpage}{%
    \newpage
  }{}
  
  \begin{minipage}{\linewidth}%
    \vspace{.2in}%
    \noindent{\textbf{\IfNoValueTF{#1}%
        {\questiontype}%
        {\@ifmtarg{#1}{\questiontype}{#1}}%
        \ %
        \IfNoValueTF{#2}%
        {\arabic{problemCounter}}%
        {\@ifmtarg{#2}{\arabic{problemCounter}}{#2}}%
      }}%
    \vspace{0.3em} \hrule \vspace{.1in}
  \end{minipage}%
  \IfNoValueTF{#2}{\stepcounter{problemCounter}}{\@ifmtarg{#2}{\stepcounter{problemCounter}}{\IfInteger{#2}{\setcounter{problemCounter}{\numexpr#2+1\relax}}}}
  
}

\NewDocumentCommand{\Problem}{o o}{\problem[#1][#2]{}}

% ----- Page Setup ------------------------------------------------------------

% Use block style paragraphs
\setlength{\parindent}{0pt}
\setlength{\parskip}{5pt plus 1pt}

\def\indented#1{\list{}{}\item[]}
\let\indented=\endlist


% ----- Custom Settings -------------------------------------------------------

% Alphanumeric enumerate
\providecommand{\labelenumi}{(\alph{enumi})}
\renewcommand{\labelenumi}{(\alph{enumi})}

% ----- Title & Header --------------------------------------------------------
\pagestyle{empty}
\pagestyle{fancy}

\providecommand{\callhypersetup}{\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    filecolor=magenta,
    urlcolor=cyan,
    pdftitle={\hwclass{} \hwtype{} \hwnum{}},
    pdfauthor=\hwname{},
  }
}

\renewcommand{\maketitle}[0]{%
  % Setup header
  \setlength{\headheight}{15.2pt}
  \setlength{\headsep}{0.2in}
  \lhead{\hwclassnum{}}%
  \chead{\hwname{}}%
  \rhead{\hwtype{} \hwnum}%
  
  % Setup hrule in header
  \renewcommand{\headrulewidth}{0pt}
  \headrule{}
  
  % Don't put header on first page
  \thispagestyle{plain}
  
  \begin{center}
    {\LARGE \hwtype{} \hwnum}
    
    {\large \hwclassnum{} \hwclass{}}
    
    \hwname{} (\hwemail)
    
    \Filemodtoday{\jobname}
  \end{center}
  \renewcommand{\headrulewidth}{0.4pt}
}


% ----- Math Macros -----------------------------------------------------------

% "Operators"
\DeclareMathOperator{\ord}{ord}
\DeclareMathOperator{\arcsec}{arcsec}
\DeclareMathOperator{\Hom}{Hom}
\DeclareMathOperator{\arccot}{arccot}
\DeclareMathOperator{\arccsc}{arccsc}
\DeclareMathOperator{\Arg}{Arg}
\DeclareMathOperator{\Ker}{Ker}
\DeclareMathOperator{\im}{Im}
\DeclareMathOperator{\Aut}{Aut}
\DeclareMathOperator{\Iso}{Iso}
\DeclareMathOperator{\GL}{GL}
\DeclareMathOperator{\lub}{lub}
\DeclareMathOperator{\glb}{glb}

% Shortened character commands
\newcommand{\cross}{\times}
\newcommand{\grad}{\mathbf\nabla}
\newcommand{\wh}{\widehat}
\newcommand{\vep}{\varepsilon}
\newcommand{\la}{\langle}
\newcommand{\ra}{\rangle}

% Modifiers
\newcommand{\abs}[1]{\left\lvert #1 \right\rvert}
\newcommand{\ol}[1]{\overline{#1}}
\newcommand{\ul}[1]{\underline{#1}}
\newcommand{\innerprod}[1]{\left\langle #1 \right\rangle}


% Blackface Bold
\newcommand{\bd}{\mathbb D}
\newcommand{\bz}{\mathbb Z}
\newcommand{\bn}{\mathbb N}
\newcommand{\bq}{\mathbb Q}
\newcommand{\br}{\mathbb R}
\newcommand{\bc}{\mathbb C}
\newcommand{\bF}{\mathbb F}
\newcommand{\bh}{\mathbb H}


% -----------------------------------------------------------------------------
