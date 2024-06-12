\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{vestnik}[2024/03/28 version 3.0.15]

% 2023/10/10 v3.0.14 - Исправлена поддержка англоязычных статей

\message
 {^^J=============================================================
  ^^J  VESTNIK 3.0.15 (2024/03/28) LaTeX2e paper class for journal 
  ^^J  'Ecological Bulletin of Research Centers of the BSEC'
  ^^J=============================================================^^J^^J}
\makeatletter
\newlinechar=`\^^J
\def\class@warning#1{%
    \ClassWarningNoLine{vestnik}{#1}
}
\def\class@error#1{%
    \ClassError{vestnik}{#1}{See LaTeX Documentation for more help}
}
%\RequirePackage{expl3}

\newif\if@windows\@windowsfalse%
\newif\if@english\@englishfalse%
\newif\if@draft\@draftfalse%
\newif\if@press\@pressfalse%
\newif\if@pdf
\ifx\pdfoutput\undefined\@pdffalse 
	\else\pdfoutput=1\@pdftrue
\fi

\DeclareOption{english}{\@englishtrue}
\DeclareOption{cp1251}{\@windowstrue}
\DeclareOption{draft}{\@drafttrue}
\DeclareOption{press}{\@presstrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\def\@classoptionslist{a4paper,twoside}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage{pstricks}

\RequirePackage[hyphens]{url}
\RequirePackage{hyperref}
\RequirePackage{xcolor}
	
\ifx\finishrun\undefined
\else
%	\RequirePackage[a-1b]{pdfx}
\fi

\if@draft
    \RequirePackage{pdfcomment}
    \defineliststyle{vestnik}{%
         {\pc@lopt@author}: \textcolor{black}{\pc@lopt@comment}}
    \setliststyle{vestnik}
    \newcommand{\ec}[2]{\pdfmarkupcomment[color=yellow,author=Редактор,subject={Note}]{#1}{#2}}
    \newcommand{\rc}[2]{\pdfmarkupcomment[color=yellow,author=Рецензент,subject={Note}]{#1}{#2}}
    \newcommand{\editorcc}[1]{%
		\pdfmargincomment[color=red,author=Редактор,icon=Help,width=0pt,height=0pt]{#1}}
    \newcommand{\editorc}[1]{%
		\marginpar{\pdfcomment[color=red,author=Редактор,icon=Help,width=0pt,height=0pt]{#1}}}
    \newcommand{\reviewerc}[1]{%
\marginpar{\pdfcomment[color=red,author=Рецензент,icon=Help,width=0pt,height=0pt]{#1}}}
\fi

\RequirePackage[warn]{mathtext}

\RequirePackage[T2A]{fontenc}
\if@windows
    \RequirePackage[cp1251]{inputenc}
    \RequirePackage{cm-super}
\else
    \RequirePackage[utf8]{inputenc}
\fi
\RequirePackage[english,russian]{babel}
%\usepackage[a-1b]{pdfx}

\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{cite,indentfirst,fancyhdr}
\DeclareTextCommand{\textunderscore}{OT1}{\leavevmode\vbox{\hrule width 1em}}
\RequirePackage{underscore}

\def\citemid{\ignorespaces\penalty9999}

\if@pdf
	\RequirePackage[pdftex]{graphicx}
	\RequirePackage{microtype}
	\pdfcompresslevel=9
\else
	\RequirePackage{graphicx}
\fi
\graphicspath{{_fig/}}

\if@draft
	\usepackage{draftwatermark}
\fi
	
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4}
\renewcommand{\topfraction}{0.85}
\renewcommand{\textfraction}{0.1}
\renewcommand{\floatpagefraction}{0.9}

\RequirePackage[center,small,labelsep=period,skip=5pt]{caption}
\long\def\captionf#1{%
	\addtocounter{figure}{-1}%
	\captionsetup{font=footnotesize,font+=it,name=Fig.,skip=5pt}%
	\caption{#1}%
}
\long\def\captiont#1{%
	\addtocounter{table}{-1}%
	\captionsetup{font=footnotesize,font+=it,name=Table,skip=5pt}%
	\caption{#1}%
	\vspace{3pt}
}
\RequirePackage{subcaption}
\renewcommand\thesubfigure{\asbuk{subfigure}}
\DeclareCaptionLabelFormat{opening}{#2)}
\captionsetup[subfigure]{labelformat=opening}

\RequirePackage{rotating,epstopdf,tabularx}
\RequirePackage{newfile}
%\RequirePackage{titlecaps}
%\Addlcwords{a an the for and or nor but as yet so in on at by from to is of with}
%\def\converttilde{T}
\RequirePackage[misc]{ifsym}
\RequirePackage[normalem]{ulem}
\RequirePackage{lastpage}
\RequirePackage[mathlines]{lineno}
\setlength\linenumbersep{1cm}

\RequirePackage[mag=1000,a4paper,%
                inner=3cm,outer=3cm,top=2.5cm,bottom=2.5cm,
                includeheadfoot,
                ]{geometry}
\if@draft\if@press
    \RequirePackage{showframe}
    \renewcommand*\ShowFrameLinethickness{.05pt}
    \renewcommand*\ShowFrameColor{\color{gray}}
\fi\fi
\renewcommand{\baselinestretch}{.98}\selectfont
\renewcommand\linespread[1]{%
	\renewcommand{\baselinestretch}{#1}\selectfont
}

\binoppenalty=10000 \relpenalty=10000
\clubpenalty=10000 \widowpenalty=10000

\tolerance=100
\hbadness=10

\defineshorthand[russian]{"/}{\mbox{-}\bbl@allowhyphens}

\RequirePackage{ifthen}
\RequirePackage{xstring}
%\RequirePackage{pdftexcmds}

%%%%%%% Smart comma in math mode
\if@english\relax\else
	\mathchardef\mathcomma\mathcode`\,
	\mathcode`\,="8000
	\bgroup
		\uccode`\~`\,%
		\uppercase{%
	\egroup
		\def~}{\futurelet\@let@token\v@comma}
	\newcommand\ordcommalist{0123456789}
	\def\v@comma{%
		\let\@tempb\@empty
		\expandafter\@tfor\expandafter\@tempa\expandafter:\expandafter=%
		\ordcommalist\do{%
		\expandafter\ifx\@tempa\@let@token
		\let\@tempb\mathord \@break@tfor
		\fi
		}%
	\@tempb\mathcomma
	}
\fi

%%%%%%% Strings definitions
\def\YEAR{}
\def\VOLUME{}
\def\ISSUE{}
\def\PRESSDATE{}

\def\s@issn{1729-5459%
}
\def\s@doiprefix{10.31429%
}
\def\s@ru@journalname{%
	\if@english\select@ru\fi%
	Экологический вестник научных центров Черноморского экономического сотрудничества%
	\if@english\select@en\fi%
}
\def\s@ru@journalshortname{%
	\if@english\select@ru\fi%
	Экологический вестник научных центров ЧЭС%
	\if@english\select@en\fi
}
\def\s@ru@journalfullname{%
	\if@english\select@ru\fi%
	Экологический вестник научных центров Черноморского~экономического сотрудничества (ЧЭС)%
	\if@english\select@en\fi%
}
\def\s@en@journalname{Eco\-lo\-gi\-cal Bul\-le\-tin of Re\-search Cen\-ters of the Black Sea Eco\-no\-mic Co\-ope\-ra\-tion%
}
\def\s@en@journalshortname{Eco\-lo\-gi\-cal Bul\-le\-tin of Re\-search Cen\-ters of~the~BSEC%
}
\def\s@ru@phone{+7~(918)~0886651%
}
\def\s@en@phone{+7~918~0886651%
}
\def\s@ru@udc{%
	\if@english\select@ru\fi%
	УДК%
	\if@english\select@en\fi%
}
\def\s@orcid{ORCID%
}
\def\s@spin{SPIN%
}
\def\s@email{\mbox{e-mail}%
}
\def\s@doiurlprefix{https://doi.org/%
}
\def\s@orcidurlprefix{https://orcid.org/%
}
\def\s@ednurlprefix{https://elibrary.ru/%
}
\def\s@ru@corresponding{%
	\if@english\select@ru\fi%
	Адреса и телефоны для связи%
	\if@english\select@en\fi%
}
\def\s@en@corresponding{Addresses and phone(s)%
}
\def\s@ru@abstract{%
	\if@english\select@ru\fi%
	Аннотация.%
	\if@english\select@en\fi%
}
\def\s@en@abstract{Abstract.%
}
\def\s@ru@keywords{%
	\if@english\select@ru\fi%
	Ключевые\;слова:%
	\if@english\select@en\fi%
}
\def\s@en@keywords{Keywords:%
}
\def\s@ru@funding{%
	\if@english\select@ru\fi%
	Финансирование.%
	\if@english\select@en\fi%
}
\def\s@en@funding{Funding.%
}
\def\s@ru@nofunding{%
	\if@english\select@ru\fi%
	Исследование не имело спонсорской поддержки.%
	\if@english\select@en\fi%
}
\def\s@en@nofunding{The study did not have sponsorship.%
}
\def\s@ru@noconflictofinterest{%
	\if@english\select@ru\fi%
	Автор заявляет об отсутствии конфликта интересов.%
	\if@english\select@en\fi%
}
\def\s@ru@noconflictofinterestmany{%
	\if@english\select@ru\fi%
	Авторы заявляют об отсутствии конфликта интересов.%
	\if@english\select@en\fi%
}
\def\s@en@noconflictofinterest{The author declare no competing interests.%
}
\def\s@en@noconflictofinterestmany{The authors declare no competing interests.%
}
\def\s@ru@nocontribution{%
	\if@english\select@ru\fi%
	Авторы внесли одинаковый вклад в подготовку рукописи.%
	\if@english\select@en\fi%
}
\def\s@en@nocontribution{The authors contributed equally.%
}
\def\s@ru@citeas{%
	\if@english\select@ru\fi%
	Цитирование:%
	\if@english\select@en\fi%
}
\def\s@en@citeas{Cite\;as:%
}
\def\s@ru@daterecived{%
	\if@english\select@ru\fi%
	Поступила%
	\if@english\select@en\fi%
}
\def\s@en@daterecived{Received%
}
\def\s@ru@daterevised{%
	\if@english\select@ru\fi%
	После доработки%
	\if@english\select@en\fi
}
\def\s@en@daterevised{Revised%
}
\def\s@ru@dateaccepted{%
	\if@english\select@ru\fi%
	Принято%
	\if@english\select@en\fi%
}
\def\s@en@dateaccepted{Accepted%
}
\def\s@ru@datepress{%
	\if@english\select@ru\fi%
	Публикация%
	\if@english\select@en\fi%
}
\def\s@en@datepress{Published%
}
\def\s@ru@authorscopyright{%
	\if@english\select@ru\fi%
	Автор(ы)%
	\if@english\select@en\fi%
}
\def\s@en@authorscopyright{The Author(s)%
}
\def\s@ru@cccopyright{%
	\if@english\select@ru\fi%
	Статья открытого доступа, распространяется по лицензии \href{https://creativecommons.org/licenses/by/4.0/deed.ru}{Creative Commons Attribution 4.0 (CC\,BY)}.%
	\if@english\select@en\fi%
}
\def\s@en@cccopyright{The article is open access, distributed under \href{https://creativecommons.org/licenses/by/4.0/deed.en}{Creative Commons Attribution 4.0 (CC\,BY) license}.%
}
\def\s@ru@authorsinfo{%
	\if@english\select@ru\fi%
	Информация об авторах%
	\if@english\select@en\fi%
}
\def\s@en@authorsinfo{Authors' Information%
}
\def\s@ru@references{Литература%
}
\def\s@en@references{References%
}
\def\s@ru@date{\IeC{\CYRD}\IeC{\cyra}\IeC{\cyrt}\IeC{\cyra}\space\IeC{\cyro}%
	\IeC {\cyrt}\IeC{\cyrp}\IeC{\cyrr}\IeC{\cyra}\IeC{\cyrv}\IeC{\cyrk}\IeC{\cyri}%
	\space\IeC{\cyrs}\IeC{\cyrt}\IeC{\cyra}\IeC{\cyrt}\IeC{\cyrsftsn}\IeC{\cyri}%
}
\def\s@en@date{Article submission date%
}
\def\s@ru@acknowledgements{%
	\if@english\select@ru\fi%
	Благодарности%
	\if@english\select@en\fi%
}
\def\s@en@acknowledgements{Acknowledgements%
}
\def\s@doi{DOI:%
}
\def\s@edn{EDN:%
}
\def\s@ru@noteslist{%
	\if@english\select@ru\fi%
	Список замечаний%
	\if@english\select@en\fi%
}

%%%%%%% Special commands

\def\affil@ru@list{}
\def\affil@en@list{}

\def\author@ru@list{}
\def\author@en@list{}
\def\author@en@listcomma{}

\def\author@ru@shortlist{}
\def\author@en@shortlist{}

\newcounter{author@ru@count}
\newcounter{author@en@count}
\newcounter{author@ru@info@count}
\newcounter{author@en@info@count}
\newcounter{author@email@count}
\newcounter{author@orcid@count}
\newcounter{author@spin@count}
\newcounter{author@address@count}
\newcounter{affil@ru@count}
\newcounter{affil@en@count}
\newcounter{orgname@ru@count}
\newcounter{orgname@en@count}
\newcounter{@tmp@ru@a}
\newcounter{@tmp@en@a}

\def\@sep{,}%
\def\@ssep{\unskip\@sep\space}
\def\@cep{;}%
\def\@scep{\@cep\space}
\def\@sspace{\hspace{1ex}}
\def\@msep{\hspace{1em}\raisebox{-2pt}{\@mbullet}\hspace{1em}}
\def\@mbullet{\raise.2em\hbox{\scalebox{.5\f@size}{$\bullet$}}}
\def\@envelope{\leavevmode\hbox{\scalebox{.9}{\text{\Letter}}}}
\def\@orcidid{\kern 1pt\raisebox{-1pt}{\hbox{\includegraphics[width=.75em]{_orcid}}}\kern .4pt}
\def\@jlogo{\raisebox{-2pt}{\hbox{\includegraphics[width=1.5em]{ev}}}\hskip 10pt }
\def\@textcopyright{\raisebox{1pt}{\scalebox{.9}{\tiny\textcopyright}}}
\ifx\No\undefined\newcommand\No{\textnumero}
    \else\renewcommand\No{\textnumero}\fi
\def\textff#1{{\small\it#1}}
%\def\textff#1{{\raisebox{.75pt}[0pt][0pt]{\scalebox{.9}%
%    {\tiny\bf\sf\uline{\MakeUppercase{#1}}}}}\hspace{3pt}}
%\def\textsb#1{\fontseries{b}\selectfont #1}
\def\textel#1{{\normalsize #1}}
\def\@sscript#1{\raisebox{-1.5pt}{$^\text{#1}$}}
\def\select@ru{\selectlanguage{russian}}
\def\select@en{\selectlanguage{english}}

%%%%%%% Users commands

\def\udc#1{\def\theudc{#1}}
\def\EDN#1{\def\theEDN{#1}}
\newcommand{\titlerus}{}
\newcommand{\thetitlerus}{}
\newcommand{\thetitlerusshort}{}
\renewcommand{\titlerus}[2][]{%
    \renewcommand{\thetitlerus}{#2}%
    \ifthenelse{\equal{#1}{}}{%
        \renewcommand{\thetitlerusshort}{\thetitlerus}}{%
        \renewcommand{\thetitlerusshort}{#1}}%
}
\newcommand{\titleeng}{}
\newcommand{\thetitleeng}{}
\newcommand{\thetitleengshort}{}
\renewcommand{\titleeng}[2][]{%
    \renewcommand{\thetitleeng}{#2}%
    \ifthenelse{\equal{#1}{}}{%
        \renewcommand{\thetitleengshort}{\thetitleeng}}{%
        \renewcommand{\thetitleengshort}{#1}}%
}
\def\addtotocrus#1{\def\theaddtotocrus{#1}}
\def\addtotoceng#1{\def\theaddtotoceng{#1}}

\def\addto@initial#1{%
	\def\@lsep{\def\@lsep{\kern 1.3pt}}%
	\g@addto@macro\@inittemp{\expandafter\@lsep#1.}%
}

\ExplSyntaxOn
\cs_new:Npn \initials_first_of_words:nn #1#2
  { \exp_not:e { \__crosfield_first_of_words:e { \text_purify:n {#2} } {#1} } }
\group_begin:
\cs_set:Npn \__crosfield_tmp:n #1
  {
    \cs_new:Npn \__crosfield_first_of_words:n ##1 ##2
      {
        \__crosfield_first_of_words_spaces:Nnw \use_none:n {##2} ##1 #1
          \q_recursion_tail #1
          \q_recursion_stop
      }
  }
\__crosfield_tmp:n { ~ }
\group_end:
\cs_generate_variant:Nn \__crosfield_first_of_words:n { e }
\cs_new:Npn \__crosfield_first_of_words_spaces:Nnw #1 #2 #3 ~
  {
    \quark_if_recursion_tail_stop:n {#3}
    #1 {#2}
    \tl_if_head_eq_meaning:oNTF {#3} \UTFviii@two@octets
      { \__crosfield_first_of_words_aux:nnw #3 \q_stop }
      { \tl_head:n {#3} }
    \__crosfield_first_of_words_spaces:Nnw \exp_not:n {#2}
  }
\cs_generate_variant:Nn \tl_if_head_eq_meaning:nNTF { o }
\cs_new:Npn \__crosfield_first_of_words_aux:nnw #1#2#3 \q_stop
  { \exp_not:n { #1#2 } }

\newcommand\Initials[1]{ \initials_first_of_words:nn {.\,} {#1} . }
\ExplSyntaxOff

%%%%%%% Author Russian commands

\def\authorrus{%
	\stepcounter{author@ru@count}
	\@ifstar\@@author@ru@corr\@@author@ru
}
\newcommand\@@author@ru[3][]{%
	\ifx&#1&\else
		\expandafter\gdef\csname @author@ru@affil\arabic{author@ru@count}\endcsname{#1}
	\fi
	\expandafter\gdef\csname @author@ru@last\arabic{author@ru@count}\endcsname{#2}
	\expandafter\gdef\csname @author@ru@first\arabic{author@ru@count}\endcsname{#3}
	\@ifnextchar[{\@addi@ru{#3}}{\relax}
%	\make@author@ru@list[#1]{#2}{#3}
}
\newcommand\@@author@ru@corr[3][]{%
	\ifx&#1&\else
		\expandafter\gdef\csname @author@ru@affil\arabic{author@ru@count}\endcsname{#1}
	\fi
	\expandafter\gdef\csname @author@ru@last\arabic{author@ru@count}\endcsname{#2}
	\expandafter\gdef\csname @author@ru@first\arabic{author@ru@count}\endcsname{#3}
	\expandafter\gdef\csname @author@ru@corr\arabic{author@ru@count}\endcsname{*}
	\@ifnextchar[{\@addi@ru{#3}}{\relax}
%	\make@author@ru@list[#1*]{#2}{#3}
}
\def\@addi@ru#1[#2]{%
	\expandafter\gdef\csname @author@ru@init\arabic{author@ru@count}\endcsname{#2}
}
\def\author@ru@headlist{%
	\newcounter{@tmp@ru@c}\stepcounter{@tmp@ru@c}
	\whiledo{\not{\value{@tmp@ru@c}>\value{author@ru@count}}}{%
		\bf\ifcsname @author@ru@init\the@tmp@ru@c\endcsname
			\@nameuse{@author@ru@init\the@tmp@ru@c}
		\else
			\Initials{\@nameuse{@author@ru@first\the@tmp@ru@c}}~%
		\fi
		\@nameuse{@author@ru@last\the@tmp@ru@c}%
		\ifcsname @author@orcid\the@tmp@ru@c\endcsname
			\ifx\finishrun\undefined
				\href{\s@orcidurlprefix\@nameuse{@author@orcid\the@tmp@ru@c}}%
					{\@orcidid}%
			\fi
		\fi%
		\expandafter%
		\ifx\csname @author@ru@affil\the@tmp@ru@c\endcsname\relax
			\def\@addkern{\kern1pt}%
		\else
			\def\@addkern{}%
		\fi%
		\expandafter%
		\ifcsname @author@ru@corr\the@tmp@ru@c\endcsname
			\def\@emark{\,\@envelope}%
		\else
			\def\@emark{}%
		\fi%
		\rm\@addkern\@sscript{\@nameuse{@author@ru@affil\the@tmp@ru@c}\@emark}%
		\ifnum\the@tmp@ru@c=\c@author@ru@count\else\@ssep\fi%
		\stepcounter{@tmp@ru@c}%
	}
}

\newcounter{@tmp@ru@e}
\def\Alr{@author@ru@last}
\def\Afr{@author@ru@first}
\def\Air{@author@ru@init}
\let\z\expandafter
\def\@make@author@ru@list{%
    \whiledo{\value{@tmp@ru@e} < \value{author@ru@count}}{%
        \stepcounter{@tmp@ru@e}%
        \edef\Thei{\the@tmp@ru@e}%
        \z\z\z\g@addto@macro\z\z\z\author@ru@list\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Alr\z\Thei\z}\z~}%
		\ifcsname @author@ru@init\the@tmp@ru@e\endcsname
        \z\z\z\g@addto@macro\z\z\z\author@ru@list\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Air\z\Thei\z}\z}
		\else
        \z\z\z\g@addto@macro\z\z\z\author@ru@list\z\z\z{\z 
            \Initials\z{\z\@nameuse\z{\z\Afr\Thei}}}
		\fi%
        \ifthenelse{\the@tmp@ru@e = \theauthor@ru@count}{}
            {\g@addto@macro\author@ru@list{\@ssep}%
        }%
    }
}
\newcommand\@make@author@ru@shortlist{%
	\g@addto@macro\author@ru@shortlist{%
		\@nameuse{@author@ru@last1}~%
		\ifcsname @author@ru@init1\endcsname%
			\@nameuse{@author@ru@init1}%
		\else%
			\Initials{\@nameuse{@author@ru@first1}}%
		\fi%
	}%
	\ifthenelse{\value{author@ru@count}=1}{}
		{\ifthenelse{\value{author@ru@count}=2}
			{\g@addto@macro\author@ru@shortlist{%
				\@ssep\@nameuse{@author@ru@last2}~%
					\ifcsname @author@ru@init2\endcsname%
						\@nameuse{@author@ru@init2}%
					\else%
						\Initials{\@nameuse{@author@ru@first2}}%
					\fi%
				}%
			}
			{\g@addto@macro\author@ru@shortlist{ и др.}}
		}
}
\newcommand{\author@ru@corrstring}{%
	\newcounter{@temp@ru@d}\stepcounter{@temp@ru@d}
	\whiledo{\not{\value{@temp@ru@d}>\value{author@ru@count}}}{%
		\expandafter%
		\ifx\csname @author@ru@corr\the@temp@ru@d\endcsname\relax
		\else
			\def\@tmp{\@nameuse{@author@email\the@temp@ru@d}}
    		\@sscript{\@envelope}\,%
			\@nameuse{@author@ru@last\the@temp@ru@d}
			\@nameuse{@author@ru@first\the@temp@ru@d};
			\ifcsname @author@orcid\the@temp@ru@d\endcsname
				ORCID \@nameuse{@author@orcid\the@temp@ru@d};
			\fi
			\ifcsname @author@spin\the@temp@ru@d\endcsname
				SPIN \@nameuse{@author@spin\the@temp@ru@d};
			\fi
    		\s@email:~\href{mailto:\@tmp}{\@tmp}\par
		\fi
	\stepcounter{@temp@ru@d}
	}
}

%%%%%%% Author Russian Info and Affiliations commands
\def\inforus#1{%
	\stepcounter{author@ru@info@count}
	\ifnum\value{author@ru@info@count}<\value{author@ru@count}
		\setcounter{author@ru@info@count}{\value{author@ru@count}}
	\fi
	\expandafter\gdef\csname @author@ru@info\arabic{author@ru@info@count}\endcsname{#1}
}
\def\email#1{%
	\stepcounter{author@email@count}%
	\ifnum\value{author@email@count}<\value{author@ru@count}
		\class@error{One or more \noexpand\email not defined}
		\setcounter{author@email@count}{\value{author@ru@count}}
	\fi
	\expandafter\gdef\csname @author@email\arabic{author@email@count}\endcsname{#1}%
}
\def\orcid#1{%
	\stepcounter{author@orcid@count}%
	\ifnum\value{author@orcid@count}<\value{author@ru@count}
		\setcounter{author@orcid@count}{\value{author@ru@count}}
	\fi
	\expandafter\gdef\csname @author@orcid\arabic{author@orcid@count}\endcsname{#1}%
}
\def\spin#1{%
	\stepcounter{author@spin@count}%
	\ifnum\value{author@spin@count}<\value{author@ru@count}
		\setcounter{author@spin@count}{\value{author@ru@count}}
	\fi
	\expandafter\gdef\csname @author@spin\arabic{author@spin@count}\endcsname{#1}%
}
\def\address#1{%
	\stepcounter{author@address@count}%
	\ifnum\value{author@address@count}<\value{author@ru@count}
		\setcounter{author@address@count}{\value{author@ru@count}}
	\fi
	\expandafter\gdef\csname @author@address\arabic{author@address@count}\endcsname{#1}%
}
\def\@make@author@ru@infolist{%
	\whiledo{\value{@tmp@ru@a}<\value{author@ru@count}}{
		\stepcounter{@tmp@ru@a}
		\edef\@tmp@ru@b{\the@tmp@ru@a}%
		\expandafter\@addto@ru@infolist\expandafter{\@tmp@ru@b}
	}
}
\def\author@ru@infoliststring{}
\def\@addto@ru@infolist#1{
	\g@addto@macro\author@ru@infoliststring{%
		\author@ru@author{#1}
		\author@ru@info{#1}\par}
}
\def\author@ru@author#1{%
	\@nameuse{@author@ru@last#1}
	\@nameuse{@author@ru@first#1}%
}
\def\author@ru@info#1{%
	\expandafter%
	\ifx\csname @author@ru@info#1\endcsname\relax
	\else
		\unskip\@ssep%
		\@nameuse{@author@ru@info#1}%
	\fi%
	\expandafter%
	\ifx\csname @author@orcid#1\endcsname\relax
	\else
		\unskip\@scep\s@orcid\space\@nameuse{@author@orcid#1}%
	\fi%
	\expandafter%
	\ifx\csname @author@spin#1\endcsname\relax
	\else
		\unskip\@scep\s@spin\space\@nameuse{@author@spin#1}%
	\fi%
	\expandafter%
	\ifx\csname @author@email#1\endcsname\relax
	\else
		\unskip\@scep\s@email:\space\mbox{\@nameuse{@author@email#1}}%
	\fi.%
}
\newcounter{affil@ru@totalcount}
\setcounter{affil@ru@totalcount}{99}
\newcommand{\affilrus}[2][]{%
	\begingroup
%	\def\orgname#1{\expandafter\gdef\csname @affil@ru@orgname\arabic{affil@ru@count}\endcsname{#1}}
	
	\stepcounter{affil@ru@count}
	\ifnum\theaffil@ru@count<\theaffil@ru@totalcount
    	\expandafter\gdef\csname @affil@ru@affil\arabic{affil@ru@count}\endcsname{#1}
    	\expandafter\gdef\csname @affil@ru@name\arabic{affil@ru@count}\endcsname{#2}
    	\make@affil@ru@list[#1]{#2}
	\fi
	\endgroup%
}
\newcommand{\make@affil@ru@list}[2][]{
	\xdef\affil@ru@list{%
		\ifx\affil@ru@list\@empty%
			\unexpanded{\ifx#1\empty\else\@sscript{#1}\ \fi#2}%
		\else
    		\unexpanded\expandafter{\affil@ru@list}\par%
    		\unexpanded{\ifx#1\empty\else\@sscript{#1}\ \fi#2}%
		\fi
	}%
}

%%%%%%% Author English commands

\def\authoreng{%
	\stepcounter{author@en@count}
	\@ifstar\@@author@en@corr\@@author@en
}
\newcommand{\@@author@en}[3][]{%
	\ifx&#1&\else
		\expandafter\gdef\csname @author@en@affil\arabic{author@en@count}\endcsname{#1}
	\fi
	\expandafter\gdef\csname @author@en@last\arabic{author@en@count}\endcsname{#2}
	\expandafter\gdef\csname @author@en@first\arabic{author@en@count}\endcsname{#3}
	\@ifnextchar[{\@addi@en{#3}}{\relax}
%	\make@author@en@list[#1]{#2}{#3}
}
\newcommand{\@@author@en@corr}[3][]{%
	\ifx&#1&\else
		\expandafter\gdef\csname @author@en@affil\arabic{author@en@count}\endcsname{#1}
	\fi
	\expandafter\gdef\csname @author@en@last\arabic{author@en@count}\endcsname{#2}
	\expandafter\gdef\csname @author@en@first\arabic{author@en@count}\endcsname{#3}
	\expandafter\gdef\csname @author@en@corr\arabic{author@en@count}\endcsname{*}
	\@ifnextchar[{\@addi@en{#3}}{\relax}
%	\make@author@en@list[#1*]{#2}{#3}
}
\def\@addi@en#1[#2]{%
	\expandafter\gdef\csname @author@en@init\arabic{author@en@count}\endcsname{#2}
}
\newcommand\author@en@headlist{%
	\newcounter{@tmp@en@c}\stepcounter{@tmp@en@c}
	\whiledo{\not{\value{@tmp@en@c}>\value{author@en@count}}}{%
		\bf\ifcsname @author@en@init\the@tmp@en@c\endcsname
			\@nameuse{@author@en@init\the@tmp@en@c}
		\else
			\Initials{\@nameuse{@author@en@first\the@tmp@en@c}}~%
		\fi
		\@nameuse{@author@en@last\the@tmp@en@c}%
		\expandafter%
		\ifx\csname @author@en@affil\the@tmp@en@c\endcsname\relax
			\def\@addkern{\kern1pt}%
		\else
			\def\@addkern{}%
		\fi%
		\expandafter%
		\ifcsname @author@en@corr\the@tmp@en@c\endcsname
			\def\@emark{\,\@envelope}%
		\else
			\def\@emark{}%
		\fi%
		\rm\@addkern\@sscript{\@nameuse{@author@en@affil\the@tmp@en@c}\@emark}%
		\ifnum\the@tmp@en@c=\c@author@en@count\else\@ssep\fi%
		\stepcounter{@tmp@en@c}%
	}%
}
\newcounter{@tmp@en@e}
\def\Ale{@author@en@last}
\def\Afe{@author@en@first}
\def\Aie{@author@en@init}
\let\z\expandafter
\def\@make@author@en@list{%
    \whiledo{\value{@tmp@en@e} < \value{author@en@count}}{%
        \stepcounter{@tmp@en@e}%
        \edef\Thei{\the@tmp@en@e}%
        \z\z\z\g@addto@macro\z\z\z\author@en@list\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Ale\z\Thei\z}\z~}%
        \z\z\z\g@addto@macro\z\z\z\author@en@listcomma\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Ale\z\Thei\z}\z,~}%
		\ifcsname @author@en@init\the@tmp@en@e\endcsname
        \z\z\z\g@addto@macro\z\z\z\author@en@list\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Aie\z\Thei\z}\z}
        \z\z\z\g@addto@macro\z\z\z\author@en@listcomma\z\z\z{\z\z\z
            \@nameuse\z\z\z{\z\z\z\Aie\z\Thei\z}\z}
		\else
        \z\z\z\g@addto@macro\z\z\z\author@en@list\z\z\z{\z 
            \Initials\z{\z\@nameuse\z{\z\Afe\Thei}}}
        \z\z\z\g@addto@macro\z\z\z\author@en@listcomma\z\z\z{\z 
            \Initials\z{\z\@nameuse\z{\z\Afe\Thei}}}
		\fi%
        \ifthenelse{\the@tmp@en@e = \theauthor@en@count}{%
        	\g@addto@macro\author@en@listcomma{\@sep}
        	}
            {\g@addto@macro\author@en@list{\@ssep}%
            \g@addto@macro\author@en@listcomma{\@ssep}%
        	}%
    }
}
\newcommand\@make@author@en@shortlist{%
	\g@addto@macro\author@en@shortlist{%
		\@nameuse{@author@en@last1}~%
		\ifcsname @author@en@init1\endcsname%
			\@nameuse{@author@en@init1}%
		\else%
			\Initials{\@nameuse{@author@en@first1}}%
		\fi%
	}%
	\ifthenelse{\value{author@en@count}=1}{}
		{\ifthenelse{\value{author@en@count}=2}
			{\g@addto@macro\author@en@shortlist{%
				\@ssep\@nameuse{@author@en@last2}~%
					\ifcsname @author@en@init2\endcsname%
						\@nameuse{@author@en@init2}%
					\else%
						\Initials{\@nameuse{@author@en@first2}}%
					\fi%
				}%
			}
			{\g@addto@macro\author@en@shortlist{ et al.}}
		}
}
\newcommand{\author@en@corrstring}{%
	\newcounter{@temp@en@d}\stepcounter{@temp@en@d}
	\whiledo{\not{\value{@temp@en@d}>\value{author@en@count}}}{%
		\expandafter%
		\ifx\csname @author@en@corr\the@temp@en@d\endcsname\relax
		\else
			\def\@tmp{\@nameuse{@author@email\the@temp@en@d}}
    		\@sscript{\@envelope}\,%
			\@nameuse{@author@en@first\the@temp@en@d}
			\@nameuse{@author@en@last\the@temp@en@d};
			\ifcsname @author@orcid\the@temp@en@d\endcsname
				ORCID \@nameuse{@author@orcid\the@temp@en@d};
			\fi	
    		\s@email:~\href{mailto:\@tmp}{\@tmp}\par
		\fi
	\stepcounter{@temp@en@d}
	}
}

%%%%%%% Author English Info and Affiliations commands

\def\infoeng#1{%
	\stepcounter{author@en@info@count}
	\ifnum\value{author@en@info@count}<\value{author@en@count}
		\setcounter{author@en@info@count}{\value{author@en@count}}
	\fi
	\expandafter\gdef\csname @author@en@info\arabic{author@en@info@count}\endcsname{#1}
}
\def\@make@author@en@infolist{%
	\whiledo{\value{@tmp@en@a}<\value{author@en@count}}{
		\stepcounter{@tmp@en@a}
		\edef\@tmp@en@b{\the@tmp@en@a}%
		\expandafter\@addto@en@infolist\expandafter{\@tmp@en@b}
	}
}
\def\author@en@infoliststring{}
\def\@addto@en@infolist#1{
	\g@addto@macro\author@en@infoliststring{%
		\author@en@author{#1}%
		\author@en@info{#1}\par}
}
\def\author@en@author#1{%
	\@nameuse{@author@en@last#1}
	\@nameuse{@author@en@first#1}%
}
\def\author@en@info#1{%
	\expandafter%
	\ifx\csname @author@en@info#1\endcsname\relax
	\else
		\unskip\@ssep%
		\@nameuse{@author@en@info#1}%
	\fi%
	\expandafter%
	\ifx\csname @author@orcid#1\endcsname\relax
	\else
		\unskip\@scep\s@orcid\space\@nameuse{@author@orcid#1}%
	\fi%
	\expandafter%
	\ifx\csname @author@email#1\endcsname\relax
	\else
		\unskip\@scep\s@email:\space\@nameuse{@author@email#1}%
	\fi.%
}
\newcounter{affil@en@totalcount}
\setcounter{affil@en@totalcount}{99}
\newcommand{\affileng}[2][]{%
	\stepcounter{affil@en@count}
	\ifnum\theaffil@en@count<\theaffil@en@totalcount
    	\expandafter\gdef\csname @affil@en@affil\arabic{affil@en@count}\endcsname{#1}
    	\expandafter\gdef\csname @affil@en@name\arabic{affil@en@count}\endcsname{#2}
    	\make@affil@en@list[#1]{#2}
	\fi
}
\newcommand{\make@affil@en@list}[2][]{
	\xdef\affil@en@list{%
		\ifx\affil@en@list\@empty%
			\unexpanded{\ifx#1\empty\else\@sscript{#1}\ \fi#2}%
		\else
    		\unexpanded\expandafter{\affil@en@list}\par%
    		\unexpanded{\ifx#1\empty\else\@sscript{#1}\ \fi#2}%
		\fi
	}%
}

%% Address tagging 
\newcommand{\orgdiv}[1]{#1}
\newcommand{\orgname}[1]{#1}
%\newcommand{\orgname}[1]{%
%	\stepcounter{orgname@ru@count}%
%	\expandafter\gdef\csname @orgname@ru@affil\theorgname@ru@count\endcsname{\arabic{orgname@ru@count}}%
%	\expandafter\gdef\csname @affil@ru@orgname\arabic{orgname@ru@count}\endcsname{#1}#1%
%}
%\newcommand{\orgnameeng}[1]{%
%	\stepcounter{orgname@en@count}%
%	\expandafter\gdef\csname @orgname@en@affil\arabic{orgname@en@count}\endcsname{\arabic{orgname@en@count}}%
%	\expandafter\gdef\csname @orgname@en@name\arabic{orgname@en@count}\endcsname{#1}#1%
%}
\newcommand{\orgaddress}[1]{#1}
\newcommand{\street}[1]{#1}
\newcommand{\postcode}[1]{#1}
\newcommand{\city}[1]{#1}
\newcommand{\state}[1]{#1}
\newcommand{\country}[1]{#1}


%%%%%%% Article other commands

\long\def\annotationrus#1{\long\def\theannotationrus{#1}}
\long\def\annotationeng#1{\long\def\theannotationeng{#1}}
\def\and{\unskip, }

\def\keywordsrus#1{\def\thekeywordsrus{#1}}
\def\keywordseng#1{\def\thekeywordseng{#1}}

\long\def\fundingrus#1{\long\def\thefundingrus{#1}}
\ifdefined\thefundingrus\else\def\thefundingrus{}\fi

\long\def\fundingeng#1{\long\def\thefundingeng{#1}}
\ifdefined\thefundingeng\else\def\thefundingeng{}\fi

\def\conflictofinterestrus#1{\def\theconflictofinterestrus{#1}}
\ifdefined\theconflictofinterestrus\else\def\theconflictofinterestrus{}\fi

\def\conflictofinteresteng#1{\def\theconflictofinteresteng{#1}}
\ifdefined\theconflictofinteresteng\else\def\theconflictofinteresteng{}\fi

\def\contributionrus#1{\def\thecontributionrus{#1}}
\ifdefined\thecontributionrus\else\def\thecontributionrus{}\fi

\def\contributioneng#1{\def\thecontributioneng{#1}}
\ifdefined\thecontributioneng\else\def\thecontributioneng{}\fi

\newcommand\reviewer[3][]{%
	\setcounter{affil@ru@totalcount}{\theaffil@ru@count}%
	\setcounter{affil@en@totalcount}{\theaffil@en@count}%
	\def\thereviewer@last{#2}
	\def\thereviewer@first{#3}
}
\long\def\inforev#1{\long\def\theinforev{#1}}
\long\def\affilrev#1{\long\def\theaffilrev{#1}}
\long\def\emailrev#1{\long\def\theemailrev{#1}}
\long\def\review#1{\long\def\thereview{#1}}

\long\def\thanks#1{\long\def\thethanks{#1}}
\def\date#1{\def\thedate{#1}}
\def\therevised{}
\def\revised#1{\def\therevised{#1}}
\def\theaccepted{}
\def\accepted#1{\def\theaccepted{#1}}
\def\OJS#1{\def\theOJS{#1}}
\def\VAK#1{\def\theVAK{#1}}
\def\draft#1{\def\thedraft{#1}}

\newcommand{\rubric}{}
\newcommand{\therubric}{}
\newcommand{\therubriceng}{}
\def\rubric#1{%
    \def\therubric{#1}   
	\ifnum\pdf@strcmp{\therubric}{Математика}=0
		\def\therubriceng{Mathematics}\else
	\ifnum\pdf@strcmp{\therubric}{Механика}=0
		\def\therubriceng{Mechanics}\else
	\ifnum\pdf@strcmp{\therubric}{Физика}=0
		\def\therubriceng{Physics}\else
	\def\therubriceng{}
	\fi\fi\fi
}
\def\doi#1{\s@doi~\href{{\s@doiurlprefix #1}}{#1}}

\def\dynspace{%
    \@ifnextchar ,{}{%
        \@ifnextchar .{}{\ }%
    }%
}%

\def\edn#1{\s@edn\space\href{{\s@ednurlprefix #1}}{#1}\dynspace}

\newcommand{\doicurrent}{%
    \s@doiprefix/vestnik-\VOLUME-\ISSUE-\FirstPage-\lastpage@lastpage%
}
\newcommand{\doidoicurrent}{%
	\ifx\VOLUME\@empty\else%
		\ifx\ISSUE\@empty\else%
			\s@doi\space\doicurrent%
		\fi%
	\fi%
}

\def\s@ru@citeaux{%
	\ifx\YEAR\@empty\else{.~\YEAR}\fi%
	\ifx\VOLUME\@empty\else{. Т.~\VOLUME}\fi%
	\ifx\ISSUE\@empty\else{, \No~\ISSUE}\fi%
	\ifx\ISSUE\@empty\else{. С.~\FirstPage--\lastpage@lastpage.}\fi%
}
\def\s@en@citeaux{%
	\ifx\YEAR\@empty\else{, \YEAR}\fi%
	\ifx\VOLUME\@empty\else{, vol.~\VOLUME}\fi%
	\ifx\ISSUE\@empty\else{, no.~\ISSUE}\fi%
	\ifx\ISSUE\@empty\else{, pp.~\FirstPage--\lastpage@lastpage.}\fi%
}
\def\make@author@infolist{%
	\vspace{4ex}
	\begingroup
		\sloppy
		\expandafter
		\ifcsname @author@ru@last1\endcsname
			\ifcsname @author@ru@info1\endcsname
				{\centering\bf\s@ru@authorsinfo\par}
				\nopagebreak
				\author@ru@infoliststring
			\fi
		\fi
		\expandafter
		\ifcsname @author@en@last1\endcsname
			\ifcsname @author@en@info1\endcsname
				{\centering\bf\s@en@authorsinfo\par}
				\nopagebreak
				\author@en@infoliststring
			\fi
		\fi
	\endgroup
}
\def\@write@author@ru@infolist{%
	\newcounter{@tmpc}
	\newoutputstream{pprfile}
    \openoutputfile{\jobname.ppr}{pprfile}
	\whiledo{\value{@tmpc}<\value{author@ru@count}}{
		\stepcounter{@tmpc}
		\addtostream{pprfile}{
			\string\addp\string{\author@ru@author{\the@tmpc}\string}
			\string\addi\string{\author@ru@info{\the@tmpc}\string}
		}
	}
	\closeoutputstream{pprfile}
}
\def\@write@author@en@infolist{%
	\newcounter{@tmpd}
	\newoutputstream{ppefile}
    \openoutputfile{\jobname.ppe}{ppefile}
	\whiledo{\value{@tmpd}<\value{author@en@count}}{
		\stepcounter{@tmpd}
		\addtostream{ppefile}{\string\addp\string{\author@en@infoliststring{\the@tmpd}\string}}
	}
	\closeoutputstream{ppefile}
}
\newcommand\@write@toc{%
	\newoutputstream{toc}
	\openoutputfile{\jobname.toc}{toc}
    \addtostream{toc}{\therubric}
    \addtostream{toc}{\theaddtotocrus}
    \addtostream{toc}{\author@ru@list}
    \addtostream{toc}{\therubriceng}
    \addtostream{toc}{\theaddtotoceng}
    \addtostream{toc}{\author@en@list}
    \closeoutputstream{toc}
}
\newcommand\makeintrotitle{
	\pagestyle{fancyintro}
	\thispagestyle{firstof}

	\IfFileExists{\jobname.ref}
		{\input{\jobname.ref}}
		{\def\FirstPage{1}}
		
	{\centering\large\textbf{\MakeUppercase{\thetitlerus}}\par}
	\vspace{8ex}
	
	\newoutputstream{toc}
	\openoutputfile{\jobname.toc}{toc}
    \addtostream{toc}{}
    \addtostream{toc}{\theaddtotocrus}
    \addtostream{toc}{}
    \addtostream{toc}{}
    \addtostream{toc}{\theaddtotoceng}
    \addtostream{toc}{}
    \closeoutputstream{toc}
}


\def\tcolor{gray}
\newcommand{\altbib}[1]{\textcolor{\tcolor}{[#1]}}

%%%%%%% Titul Page
\renewcommand\maketitle[1][1]{%
	
	\IfFileExists{\jobname.ref}
		{\input{\jobname.ref}}
		{\def\FirstPage{1}}
	\IfFileExists{_main.ref}{\input{_main.ref}}{}
	
	\if@draft\if@press\else\def\FirstPage{1}\fi\fi
		
    \ifdefined\finishrun
    	\hypersetup{allcolors=black,hidelinks=true}
    	\urlstyle{same}
    	\DeclareUrlCommand\url{\color{black}}
		\def\tcolor{black}
    \fi
    
    \if@press
    	\ifdefined\theaddtotocrus\else
    		\class@error{\noexpand\addtotocrus not defined}
    	\fi
        \ifdefined\theaddtotoceng\else
    		\class@error{\noexpand\addtotoceng not defined}
    	\fi
	\fi
	
	\setcounter{page}{\FirstPage}

	\ifdefined\thedate\else%
		\class@error{\noexpand\date command is undefined}
	\fi
				
	\setlength\parindent{0pt}
	\pagestyle{fancy}
	\thispagestyle{firststyle}
	\renewcommand{\baselinestretch}{#1}\selectfont

    \if@draft
    \if@press\SetWatermarkText{\relax}\else
		\SetWatermarkText{%
			{\rm ПРЕДВАРИТЕЛЬНАЯ КОРРЕКТУРА\ifdefined\thedraft\ \#\thedraft\fi%\\[2mm]https://vestnik.kubsu.ru/workflow/access/\theOJS
			}}
		\SetWatermarkAngle{0}
		\SetWatermarkScale{.4}
		\SetWatermarkVerCenter{14mm}
    \fi\fi

	\@make@author@ru@list
	\@make@author@en@list
    \@make@author@ru@shortlist
    \@make@author@en@shortlist
	\@make@author@ru@infolist
	\@make@author@en@infolist
	    
	\begingroup
		\parindent 0ex
		\ifdefined\theudc
			\scriptsize\s@ru@udc\space\theudc
		\fi
		\hfill
		\if@press
%			\ifnum\FirstPage=1\else
        		\ifx\VOLUME\@empty\else
            		\ifx\ISSUE\@empty\else
            			\ifdefined\theEDN\s@edn\space\href{\s@ednurlprefix \theEDN}{\theEDN}\fi
						\quad
						\s@doi\space\href{\s@doiurlprefix\doicurrent}{\doicurrent}%
        			\fi%
%				\fi%
			\fi%
		\fi%
	\endgroup%
	
	\vskip 6pt plus 2pt minus 2pt
	
	\begingroup
		\if@english
			\title@en@head[#1]
			\vskip 9pt plus 2pt minus 2pt
			\hrule
			\vskip 9pt plus 2pt minus 2pt
			\title@ru@head[#1]
		\else
			\title@ru@head[#1]
			\vskip 9pt plus 2pt minus 2pt
			\hrule
			\vskip 9pt plus 2pt minus 2pt
			\title@en@head[#1]
		\fi
	\endgroup
				
	\if@press\@write@author@ru@infolist\fi
	\if@press\@write@author@en@infolist\fi
	\if@press\@write@toc\fi
%	\if@press\@write@xml\fi
	\if@press\ifx\doicurrent\@empty\@write@doi\fi\fi
	
	\if@press\relax\else\if@draft\linenumbers\fi\fi
	\setlength\parindent{3ex}
	
	\vskip 16pt plus 3pt minus 3pt
	
	\renewcommand{\baselinestretch}{1}\selectfont
	\if@english
	%\selectlanguage{english}
	\else\frenchspacing\fi
}

\newcommand\title@ru@head[1][1]{
	\begingroup
	\select@ru
	\normalsize
%	\vspace{1ex}
	\sloppy
%	\leftskip 1.5ex\parindent -1.5ex
%	\parindent 0ex
	\begingroup
		\raggedright\par
		\renewcommand{\baselinestretch}{.9}\selectfont
		\ifdefined\thetitlerus
			\if@english\normalsize\else\Large\fi%
			\boldsymbol%
			\bgroup%
				\ifdefined\theaddtotocrus\theaddtotocrus%
				\else\thetitlerus%
				\fi%
			\egroup\par
		\fi
	\endgroup
	\begingroup
		\raggedright
		\renewcommand{\baselinestretch}{1}\selectfont
		\expandafter
		\ifcsname @author@ru@last1\endcsname
		    \if@english\vskip 4pt plus 1pt minus 1pt
		    \else\vskip 8pt plus 2pt minus 2pt
		    \fi
            \raggedright\par
            \bgroup%
            	\if@english\footnotesize\else\small\fi%
				\author@ru@headlist
			\egroup\par
		\fi
	\endgroup
	\begingroup
		\raggedright
		\expandafter
		\ifcsname @affil@ru@name1\endcsname
			\vskip 8pt plus 2pt minus 2pt
			\leftskip 1.7ex\parindent -1.7ex%
    		\footnotesize%
			\affil@ru@list\par
    		\vskip 3pt plus 1pt minus 1pt
    		\author@ru@corrstring
		\fi
	\endgroup
	\begingroup
		\ifdefined\theannotationrus
			\vskip 6pt plus 1pt minus 1pt
			\linespread{#1}
			\textff{\s@ru@abstract}\@sspace%
			\small\theannotationrus\par
		\fi
	\endgroup
	\begingroup
		\ifdefined\thekeywordsrus
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
			\textff{\s@ru@keywords}\@sspace%
			\small\thekeywordsrus\unskip.\par
		\fi
	\endgroup
	\begingroup
		\ifx\thefundingrus\@empty
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
    		\textff{\s@ru@funding}\@sspace%
			\small\s@ru@nofunding\par
		\else
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
    		\textff{\s@ru@funding}\@sspace%
			\small\thefundingrus\par
		\fi
	\endgroup
    \begingroup
		\vskip 2pt plus 1pt minus 1pt
		\linespread{#1}
		\textff{\s@ru@citeas}\@sspace%
		\small{\it\author@ru@list} \thetitlerus~// 
		\s@ru@journalname%
		\if@press
%			\ifnum\FirstPage=1\else
				\s@ru@citeaux%
				\ifdefined\theEDN\space\s@edn\space\theEDN.\fi
				\space\doidoicurrent%
%			\fi
		\fi\par
	\endgroup
	\begingroup
		\vskip 2pt plus 1pt minus 1pt
		\linespread{#1}
    	\small%
		\s@ru@daterecived\space%
		\@date@ru{\thedate}\space%
		\if@press
			\ifthenelse{\equal{\therevised}{}}
				{\class@error{\noexpand\revised not defined}}
				{\s@ru@daterevised\space\@date@ru{\therevised}}
    		\ifthenelse{\equal{\theaccepted}{}}
				{\class@error{\noexpand\accepted not defined}}
				{\s@ru@dateaccepted\space\@date@ru{\theaccepted}}
            \ifthenelse{\equal{\PRESSDATE}{}}
            	{}{\s@ru@datepress\space\@date@ru{\PRESSDATE}}
%			\ifnum\FirstPage=1\else\fi
		\fi\par
	\endgroup
	\begingroup
	\vskip 2pt plus 1pt minus 1pt
	\linespread{#1}%
		\ifnum\value{author@ru@count}<2\else
    		\ifx\thecontributionrus\@empty
    			\small\s@ru@nocontribution
    		\else
    			\small\thecontributionrus
    		\fi
		\fi
	\endgroup
	\begingroup
		\linespread{#1}
		\ifx\theconflictofinterestrus\@empty
			\ifnum\value{author@ru@count}<2
				\small\s@ru@noconflictofinterest
			\else
				\small\s@ru@noconflictofinterestmany
			\fi
		\else
			\small\theconflictofinterestrus
		\fi\par
	\endgroup
	\begingroup
		\vskip 6pt plus 2pt minus 2pt
		\scriptsize
		\par\@textcopyright\,\s@ru@authorscopyright\ifx\YEAR\@empty\else{, \YEAR}\fi.
		\s@ru@cccopyright\par
	\endgroup%
%	\vspace{1ex}
	\endgroup%
}
\newcommand\title@en@head[1][1]{
	\begingroup
%	\select@en
	\normalsize
%	\vspace{1ex}
	\sloppy
%	\leftskip 1.5ex\parindent -1.5ex
%	\parindent 0ex
	
	\begingroup
		\raggedright\par
		\renewcommand{\baselinestretch}{.9}\selectfont
		\ifdefined\thetitleeng
			\if@english\Large\else\normalsize\fi%
			\boldsymbol%
			\bgroup%
				\ifdefined\theaddtotoceng\theaddtotoceng%
				\else\thetitleeng%
				\fi%
			\egroup\par
		\fi
	\endgroup
	\begingroup
		\raggedright
		\renewcommand{\baselinestretch}{1}\selectfont
		\expandafter
		\ifcsname @author@en@last1\endcsname
		    \if@english\vskip 8pt plus 2pt minus 2pt
		    \else\vskip 4pt plus 1pt minus 1pt
		    \fi
            \raggedright\par
            \bgroup%
            	\if@english\small\else\footnotesize\fi%
				\author@en@headlist
			\egroup\par
		\fi
	\endgroup
	
	\begingroup
		\raggedright
		\expandafter
		\ifcsname @affil@en@name1\endcsname
			\vskip 6pt plus 1pt minus 1pt
			\leftskip 1.7ex\parindent -1.7ex%
    		\footnotesize%
			\affil@en@list\par
    		\vskip 3pt plus 1pt minus 1pt
    		\author@en@corrstring
		\fi
	\endgroup
	\begingroup
		\ifdefined\theannotationeng
			\vskip 6pt plus 1pt minus 1pt
			\linespread{#1}
			\textff{\s@en@abstract}\@sspace%
			\small\theannotationeng\par
		\fi
	\endgroup
	\begingroup
		\ifdefined\thekeywordseng
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
			\textff{\s@en@keywords}\@sspace%
			\small\thekeywordseng\unskip.\par
		\fi
	\endgroup
	\begingroup
		\ifx\thefundingeng\@empty
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
    		\textff{\s@en@funding}\@sspace%
			\small\s@en@nofunding\par
		\else
			\vskip 2pt plus 1pt minus 1pt
			\linespread{#1}
    		\textff{\s@en@funding}\@sspace%
			\small\thefundingeng\par
		\fi
	\endgroup
    \begingroup
		\vskip 2pt plus 1pt minus 1pt
		\linespread{#1}
		\textff{\s@en@citeas}\@sspace%
		\small\author@en@listcomma\ \thetitleeng. 
		{\it\s@en@journalname}%
		\if@press
%			\ifnum\FirstPage=1\else
				\s@en@citeaux\space\doidoicurrent
%			\fi
		\fi\par
	\endgroup
	\begingroup
		\vskip 2pt plus 1pt minus 1pt
		\linespread{#1}
		\small%
    	\s@en@daterecived\space%
		\@date@en{\thedate}\space
		\if@press
			\ifthenelse{\equal{\therevised}{}}
				{\class@error{\noexpand\revised not defined}}
				{\s@en@daterevised\space\@date@en{\therevised}}
    		\ifthenelse{\equal{\theaccepted}{}}
				{\class@error{\noexpand\accepted not defined}}
				{\s@en@dateaccepted\space\@date@en{\theaccepted}}
            \ifthenelse{\equal{\PRESSDATE}{}}
            	{}{\s@en@datepress\space\@date@en{\PRESSDATE}}
		\fi\par
	\endgroup
	\begingroup
		\vskip 2pt plus 1pt minus 1pt
    	\linespread{#1}%
		\ifnum\value{author@ru@count}<2\else
    		\ifx\thecontributioneng\@empty
    			\small\s@en@nocontribution
    		\else
    			\small\thecontributioneng
    		\fi
		\fi
	\endgroup
	\begingroup
		\linespread{#1}
		\ifx\theconflictofinteresteng\@empty
			\ifnum\value{author@en@count}<2
				\small\s@en@noconflictofinterest
			\else
				\small\s@en@noconflictofinterestmany
			\fi
		\else
			\small\theconflictofinteresteng
		\fi\par
	\endgroup
	\begingroup
		\vskip 6pt plus 2pt minus 2pt
		\scriptsize
		\par\@textcopyright\,\s@en@authorscopyright\ifx\YEAR\@empty\else{, \YEAR}\fi.
		\s@en@cccopyright\par
	\endgroup%
%	\vspace{1ex}
	\endgroup%
}

%%%%%%% Overriding sections
\renewcommand\section{\@startsection{section}{1}{0mm}%
                      {-3ex \@plus -.5ex \@minus -.2ex}%
                      {1ex \@plus.2ex \@minus -.2ex}%
                      {\@addtoreset{equation}{section}
                      \raggedright\normalfont\bf\textel}%
}
\renewcommand\subsection{\@startsection{subsection}{2}{0mm}%
                      {-2ex\@plus -.5ex \@minus -.2ex}%
                      {1ex \@plus .2ex \@minus -.2ex}%
                      {\raggedright\normalfont\normalsize\slshape}%
}
\renewcommand{\@seccntformat}[1]{%
    \csname the#1\endcsname.\space%
}

\renewcommand\thesubsection{%
    \ifnum\c@section>\z@\thesection.\fi%
    \arabic{subsection}\hskip 0.0em%
}
\renewcommand\thesubsubsection{%
    \thesubsection.\arabic{subsubsection}\hskip -0.0em%
}
\long\def\theequation{%
    \ifnum\c@section>\z@\thesection.\fi\@arabic\c@equation
}
\renewcommand\paragraph{%%
  \@startsection{paragraph}%%                        name                
                {4}%%                                level               
                {\z@}%%                              indentation         
                {1ex \@plus1ex \@minus.2ex}%%        beforeskip
                {-.5em}%%                             afterskip
                {\normalfont\normalsize\bfseries}}%% style
                
%%%%%%% Overriding lists

\def\@listI{\leftmargin\leftmargini%
    \topsep\z@ \parsep\z@ \itemsep.3ex
}
\def\@listii{\leftmargin\leftmarginii%
    \labelwidth\leftmarginii\advance\labelwidth-\labelsep
    \topsep\z@ \parsep\z@ \itemsep\z@
}
\def\itemize{\ifnum\@itemdepth>\@ne \@toodeep \else \advance\@itemdepth\@ne
    \vskip .1ex plus 0.3ex minus 0.2ex\leftmarginii 10\p@
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
%    \list{\csname\@itemitem\endcsname}%
    \list{\@mbullet}%
    {\def\makelabel##1{\hss\llap{##1}}}\fi
}
\def\enumerate{\ifnum\@enumdepth>\@ne \@toodeep \else
    \advance\@enumdepth\@ne
    \settowidth\leftmargini {\indent 9)\enskip}
    \leftmarginii 27\p@
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}\list
    {\csname label\@enumctr\endcsname}{\usecounter
        {\@enumctr}\def\makelabel##1{\hss\llap{##1}}}\fi
}
\def\labelitemi{\textbullet}
\def\labelitemii{--}
\def\labelenumi{\theenumi)}
\def\labelenumii{\theenumii)}
\def\theenumi{\arabic{enumi}}
\def\theenumii{\alph{enumii}}

    
%%%%%%% Environment for theorems, lemmas, proofs, notes, etc.
\newcounter{propctr}
\setcounter{propctr}{-1}
\newenvironment{prop}[2][\@nil]{%
	\refstepcounter{propctr}%
    \vskip 2ex
    \def\tmp{#1}%
    \ifx\tmp\@nnil{\bf#2.}\else{\bf#2\space#1.}\fi}
    {\vskip 2ex}
\DeclareRobustCommand{\qed}{%
  \ifmmode
  	\else\leavevmode\unskip\penalty9999 \hbox{}\nobreak
  \fi\space\hbox{\qedsymbol}%
}

%%%%%%% The definition for the bibliography
\renewcommand\@biblabel[1]{#1.\hfill}
\renewenvironment{thebibliography}[1]{%
%    \section*{\s@V@acknowledgementsrus\ [\s@V@acknowledgementseng]}
%    \bgroup
%        \small
%        \ifx\thefundingrus\@empty\s@V@noacknowledgementsrus
%    		\else\thefundingrus
%    	\fi\par
%        \ifx\thefundingeng\@empty\s@V@noacknowledgementseng
%    		\else\thefundingeng
%    	\fi\par
%	\egroup
%    \section*{Дополнительная информация [Additional Information]}
%    \bgroup
%        \small
%        \ifx\theconflictofinterestrus\@empty\s@V@noacknowledgementsrus
%    		\else\theconflictofinterestrus
%    	\fi\par
%        \ifx\theconflictofinteresteng\@empty\s@V@noacknowledgementseng
%    		\else\theconflictofinteresteng
%    	\fi\par
%	\egroup
	\nolinenumbers
    \section*{%
    		\if@english\s@en@references%
			\else\textbf{\s@ru@references\ [\s@en@references]}\fi%
		}%
		\renewcommand{\baselinestretch}{.95}\selectfont
        \list{\@biblabel{\@arabic\c@enumiv}}%
			{\small
			\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth%
            \advance\leftmargin\labelsep
            \@openbib@code%
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
		\sloppy
		\parskip 2pt
		\clubpenalty4000
		\@clubpenalty \clubpenalty
		\widowpenalty4000%
		\sfcode`\.\@m%
	}
	{\def\@noitemerr
		{\@latex@warning{Empty `thebibliography' environment}}%
	\endlist
	\if@draft\if@press\else%
		\section*{\textbf{Информация об авторах}}%
		\begingroup
%			\leftskip 1.2ex\parindent -1.2ex
			\parskip 1ex
			\small\author@ru@infoliststring
		\endgroup
		\listofpdfcomments[heading={\s@ru@noteslist}]
	\fi\fi
	}

%%%%%%% Overriding headers and footers
\fancypagestyle{firststyle}{
	\fancyhf{}
	\fancyhead[RO,LE]{\scriptsize\bf\textsf{\MakeUppercase{\therubric}}}
%	\fancyhead[RE,LO]{\scriptsize
%		\scalebox{.75}{\s@V@journalnamerus\ \mbullet\ ISSN\ \s@V@issn\ \mbullet\
%		\href{https://vestnik.kubsu.ru/article/view/\theOJSID}{vestnik.kubsu.ru}}
%	}
	\fancyhead[RE]{
		%\parbox[b]{.82\textwidth}{
			\tiny
			%{\it\author@ru@lf@list}\ \thetitlerus~//
			\scalebox{.95}{%
				\s@ru@journalname\if@press\s@ru@citeaux\fi%
			}%
			%\doidoicurrent
		%}
	}
	\fancyhead[LO]{
		%\parbox[b]{.82\textwidth}{
			\tiny
			%{\it\author@ru@lf@list}\ \thetitlerus~//
			\scalebox{.95}{%
				\s@ru@journalname\if@press\s@ru@citeaux\fi%
			}%
			%\doidoicurrent
		%}
	}
	\fancyfoot[RO,LE]{\scriptsize\bf\textsf{\MakeUppercase{\therubriceng}}}
	\fancyfoot[RE]{
		%\parbox[t]{.82\textwidth}{
			\tiny
			%\author@en@lf@list\ \thetitleeng.
			\scalebox{.95}{%
				\s@en@journalname\if@press\s@en@citeaux\fi%
			}%
			%\doidoicurrent
		%}
	}
	\fancyfoot[LO]{
		%\parbox[t]{.82\textwidth}{
    		\tiny
    		%\author@en@lf@list\ \thetitleeng. 
			\scalebox{.95}{%
				\s@en@journalname\if@press\s@en@citeaux\fi%
			}%
    		%\doidoicurrent
		%}
	}
%	\fancyfoot[RE,LO]{\scriptsize
%		\scalebox{.75}{\s@V@journalnameeng\ \mbullet\ ISSN\ \s@V@issn\ \mbullet\
%		\href{https://vestnik.kubsu.ru/article/view/\theOJSID}{vestnik.kubsu.ru}}
%	}
	\renewcommand{\headrulewidth}{.5pt}
	\renewcommand{\footrulewidth}{.5pt}
	
	\renewcommand{\headruleskip}{1pt}
	\renewcommand{\footruleskip}{2pt}
%	\setlength{\headsep}{10pt}
%	\setlength{\footskip}{20pt}
}
\fancypagestyle{fancy}{
	\fancyhf{}
	\fancyhead[CE]{\scriptsize\it\author@ru@shortlist~\thetitlerusshort}
	\fancyhead[CO]{\scriptsize\it\author@en@shortlist~\thetitleengshort}
	\fancyfoot[RO,LE]{\scriptsize\bf\thepage}
	\fancyfoot[RE]{\tiny\s@ru@journalname\if@press\s@ru@citeaux\fi}
	\fancyfoot[LO]{\tiny\s@en@journalname\if@press\s@en@citeaux\fi}
	\renewcommand{\headrulewidth}{0pt}
}
\fancypagestyle{fancyintro}{
	\fancyhf{}
	\fancyhead[CO,CE]{\scriptsize\it\thetitlerus}
	\fancyfoot[RO,LE]{\scriptsize\bf\thepage}
	\renewcommand{\headrulewidth}{0pt}
}
\fancypagestyle{firstof}{
	\fancyhf{}
	\fancyfoot[RO,LE]{\scriptsize\bf\thepage}
	\renewcommand{\headrulewidth}{0pt}
}
\definecolor{NavyBlue}{rgb}{0,0,0.5}
\definecolor{DarkGreen}{rgb}{0,0.39,0}
\definecolor{FireBrick}{rgb}{.7,0.13,0.13}
\definecolor{FireBrick}{rgb}{.7,0.13,0.13}
\renewcommand\UrlFont{\color{NavyBlue}\rmfamily}

\hypersetup{
	unicode=true,
	pdfpagelabels,
	pdfencoding=unicode,
    colorlinks = true,
    linkcolor=FireBrick,    % color of internal links
    citecolor=DarkGreen,    % color of links to bibliography
    anchorcolor=NavyBlue,
    urlcolor=NavyBlue,
   	pdfborder={1 1 1},
	pdfborderstyle={/S/U/W 1.5}, % underline links instead of boxes
	pdftitle={\thetitleeng},
%	pdfauthor={\author@en@list},
%	pdfsubject={\theannotationrus},
%	pdfkeywords={\thekeywordsrus}
}

\newcommand\@date@ru[1]{%
	\xsplit{#1}%
	\@day~%
	\if@english\select@ru\fi%
	\ifnum\pdf@strcmp{\@month}{1}=0 января\fi%
	\ifnum\pdf@strcmp{\@month}{2}=0 февраля\fi%
	\ifnum\pdf@strcmp{\@month}{3}=0 марта\fi%
	\ifnum\pdf@strcmp{\@month}{4}=0 апреля\fi%
	\ifnum\pdf@strcmp{\@month}{5}=0 мая\fi%
	\ifnum\pdf@strcmp{\@month}{6}=0 июня\fi%
	\ifnum\pdf@strcmp{\@month}{7}=0 июля\fi%
	\ifnum\pdf@strcmp{\@month}{8}=0 августа\fi%
	\ifnum\pdf@strcmp{\@month}{9}=0 сентября\fi%
	\ifnum\pdf@strcmp{\@month}{10}=0 октября\fi%
	\ifnum\pdf@strcmp{\@month}{11}=0 ноября\fi%
	\ifnum\pdf@strcmp{\@month}{12}=0 декабря\fi%
	~\@year~г.%
	\if@english\select@en\fi%
}
\newcommand\@date@en[1]{%
	\xsplit{#1}%
	\@day~%
	\ifnum\pdf@strcmp{\@month}{1}=0 January\fi%
	\ifnum\pdf@strcmp{\@month}{2}=0 Feb\-ru\-ary\fi%
	\ifnum\pdf@strcmp{\@month}{3}=0 March\fi%
	\ifnum\pdf@strcmp{\@month}{4}=0 April\fi%
	\ifnum\pdf@strcmp{\@month}{5}=0 May\fi%
	\ifnum\pdf@strcmp{\@month}{6}=0 June\fi%
	\ifnum\pdf@strcmp{\@month}{7}=0 July\fi%
	\ifnum\pdf@strcmp{\@month}{8}=0 August\fi%
	\ifnum\pdf@strcmp{\@month}{9}=0 Sep\-tem\-ber\fi%
	\ifnum\pdf@strcmp{\@month}{10}=0 Octo\-ber\fi%
	\ifnum\pdf@strcmp{\@month}{11}=0 Novem\-ber\fi%
	\ifnum\pdf@strcmp{\@month}{12}=0 Decem\-ber\fi%
	~\@year.%
}
\newcommand\dateiso[1]{%
	\xsplit{#1}%
	\@day.%
	\ifnum\pdf@strcmp{\@month}{1}=0 01\fi%
	\ifnum\pdf@strcmp{\@month}{2}=0 02\fi%
	\ifnum\pdf@strcmp{\@month}{3}=0 03\fi%
	\ifnum\pdf@strcmp{\@month}{4}=0 04\fi%
	\ifnum\pdf@strcmp{\@month}{5}=0 05\fi%
	\ifnum\pdf@strcmp{\@month}{6}=0 06\fi%
	\ifnum\pdf@strcmp{\@month}{7}=0 07\fi%
	\ifnum\pdf@strcmp{\@month}{8}=0 08\fi%
	\ifnum\pdf@strcmp{\@month}{9}=0 09\fi%
	\ifnum\pdf@strcmp{\@month}{10}=0 10\fi%
	\ifnum\pdf@strcmp{\@month}{11}=0 11\fi%
	\ifnum\pdf@strcmp{\@month}{12}=0 12\fi%
	.\@year%
}

\newcommand\xsplit[1]{%
	\exploregroups
	\StrBefore{#1}{-}[\@tempa]%
	\StrBehind{#1}{-}[\@tempb]%
	\def\@day{\@tempa}%
	\StrBefore{\@tempb}{-}[\@tempc]%
	\StrBehind{\@tempb}{-}[\@tempd]%
	\IfBeginWith{\@tempc}{0}{%
		\StrGobbleLeft{\@tempc}{1}[\@tempc]}{}%
	\gdef\@month{\@tempc}%
	\gdef\@year{\@tempd}%
}

\ExplSyntaxOn
\tl_new:N \l_normalize_tl
\cs_new:Npn \normalize #1 {
    \tl_set:Nn \l_normalize_tl {#1}
    \regex_replace_all:nnN { \~ } { \ } \l_normalize_tl
    \regex_replace_all:nnN { \c{,} } { } \l_normalize_tl
    \regex_replace_all:nnN { --- } { - } \l_normalize_tl
    \regex_replace_all:nnN { -- } { - } \l_normalize_tl
%    \regex_replace_all:nnN { \c{emph}\{(.*?)\} } { \c{textless} i\c{textgreater} \1 \c{textless}/i\c{textgreater} } \l_normalize_tl
    \tl_use:N \l_normalize_tl
}
\ExplSyntaxOff

\def\datetodots#1{\expandafter\xchangeformat#1\relax}
\def\xchangeformat#1-#2-#3\relax{#1.#2.#3}

\newcount\space@count
\def\spaceloop#1{%
	\loop\space\ifnum\space@count<#1\space\repeat%
}

\NewDocumentCommand\getkeywords{>{\SplitList{ , }}m}{{\ProcessList{#1}{\func}}}
\newcommand{\func}[1]{%
  \addtostream{xml}{\space\space\space<keyword>#1</keyword>}%
}

\newcommand\@write@xml{
	\newoutputstream{xml}
	\openoutputfile{\jobname.xml}{xml}
	
	%% Рубрика
	\addtostream{xml}{<section>}
	\addtostream{xml}{\space<secTitle lang="RUS">\therubric</secTitle>}
	\addtostream{xml}{\space<secTitle lang="ENG">\therubriceng</secTitle>}
	\addtostream{xml}{</section>}
	
	%% Статья
	\addtostream{xml}{<article>}
	\addtostream{xml}{\space<pages>\FirstPage-\lastpage@lastpage</pages>}
	\addtostream{xml}{\space<artType>RAR</artType>}
	
	%% Цикл авторов статьи
	\addtostream{xml}{\space<authors>}
	\newcounter{@tmpx}\newcounter{@tmpy}
	\whiledo{\value{@tmpx} < \value{author@ru@count}}{
    	\stepcounter{@tmpx}
    	\addtostream{xml}{\space\space<author num="\the@tmpx">}
	
    	\addtostream{xml}{\space\space\space<authorCodes>}
		\ifcsname @author@spin\the@tmpx\endcsname
		\addtostream{xml}{\space\space\space\space<spin>\@nameuse{@author@spin\the@tmpx}</spin>}
		\else\fi
		\ifcsname @author@orcid\the@tmpx\endcsname
    	\addtostream{xml}{\space\space\space\space<orcid>\@nameuse{@author@orcid\the@tmpx}</orcid>}
		\else\fi	
    	\addtostream{xml}{\space\space\space</authorCodes>}
		
    	\addtostream{xml}{\space\space\space<individInfo lang="RUS">}
    	\addtostream{xml}{\space\space\space\space<surname>\@nameuse{@author@ru@last\the@tmpx}</surname>}
    	\addtostream{xml}{\space\space\space\space<initials>\@nameuse{@author@ru@first\the@tmpx}</initials>}

		\setcounter{@tmpy}{1}
		\whiledo{\not{\value{@tmpy} > \value{affil@ru@count}}}{
			\expandafter
			\ifx\csname @author@ru@affil\the@tmpx\endcsname\relax
				\csname @author@ru@affil\the@tmpx\endcsname
				\addtostream{xml}{\space\space\space\space<orgName>\csname @affil@ru@name1\endcsname</orgName>}
			\else
				\StrLeft{\csname @author@ru@affil\the@tmpx\endcsname}{1}[\@author@ru@affil@tmp]
				\ifnum\@author@ru@affil@tmp=\the@tmpy
    				\addtostream{xml}{\space\space\space\space<orgName>\csname @affil@ru@name\the@tmpy\endcsname</orgName>}
				\else\fi
			\fi
			\stepcounter{@tmpy}
		}
    	\addtostream{xml}{\space\space\space\space<email>\@nameuse{@author@email\the@tmpx}</email>}
    	\addtostream{xml}{\space\space\space\space<otherInfo>\@nameuse{@author@ru@info\the@tmpx}</otherInfo>}
    	\addtostream{xml}{\space\space\space</individInfo>}
	
    	\addtostream{xml}{\space\space\space<individInfo lang="ENG">}
    	\addtostream{xml}{\space\space\space\space<surname>\@nameuse{@author@en@last\the@tmpx}</surname>}
    	\addtostream{xml}{\space\space\space\space<initials>\@nameuse{@author@en@first\the@tmpx}</initials>}
		
		\setcounter{@tmpy}{1}
		\whiledo{\not{\value{@tmpy} > \value{affil@en@count}}}{
			\expandafter
			\ifx\csname @author@en@affil\the@tmpx\endcsname\relax
				\csname @author@en@affil\the@tmpx\endcsname
				\addtostream{xml}{\space\space\space\space<orgName>\csname @affil@en@name1\endcsname</orgName>}
			\else
				\StrLeft{\csname @author@en@affil\the@tmpx\endcsname}{1}[\@author@en@affil@tmp]
				\ifnum\@author@en@affil@tmp=\the@tmpy
    				\addtostream{xml}{\space\space\space\space<orgName>\csname @affil@en@name\the@tmpy\endcsname</orgName>}
				\else\fi
			\fi
			\stepcounter{@tmpy}
		}
    	\addtostream{xml}{\space\space\space</individInfo>}
		\addtostream{xml}{\space\space</author>}
	}
	\ifdefined\thereviewer@last
		\stepcounter{@tmpx}
    	\addtostream{xml}{\space\space<author num="\the@tmpx">}
		\addtostream{xml}{\space\space\space<role>23</role>}
		\addtostream{xml}{\space\space\space<individInfo lang="RUS">}
    	\addtostream{xml}{\space\space\space\space<surname>\thereviewer@last</surname>}
    	\addtostream{xml}{\space\space\space\space<initials>\thereviewer@first</initials>}
		\addtostream{xml}{\space\space\space\space<email>\@nameuse{@author@email\the@tmpx}</email>}
		\addtostream{xml}{\space\space\space\space<otherInfo>\theinforev</otherInfo>}
		\addtostream{xml}{\space\space\space\space<orgName>\theaffilrev</orgName>}
		\addtostream{xml}{\space\space\space\space<comment>\thereview</comment>}
		\addtostream{xml}{\space\space\space\space<commentDate>\datetodots\therevised</commentDate>}
		\addtostream{xml}{\space\space\space</individInfo>}
		\addtostream{xml}{\space\space</author>}
	\fi
	\addtostream{xml}{\space</authors>}
	
	%% Заголовки статьи
	\addtostream{xml}{\space<artTitles>}
	\addtostream{xml}{\space\space<artTitle lang="RUS">\thetitlerus</artTitle>}
	\addtostream{xml}{\space\space<artTitle lang="ENG">\thetitleeng</artTitle>}
	\addtostream{xml}{\space</artTitles>}
	
	%% Аннотации статьи
	\addtostream{xml}{\space<abstracts>}
	\addtostream{xml}{\space\space<abstract lang="RUS">\theannotationrus</abstract>}
	\addtostream{xml}{\space\space<abstract lang="ENG">\theannotationeng</abstract>}
	\addtostream{xml}{\space</abstracts>}
	
	%% Текст статьи
	\addtostream{xml}{\space<text lang="RUS">TEXT</text>}
	
	%% Коды статьи
	\addtostream{xml}{\space<codes>}
	\addtostream{xml}{\space\space<udk>\theudc</udk>}
	\ifdefined\doicurrent
		\addtostream{xml}{\space\space<doi>\doicurrent</doi>}
	\fi
	\ifdefined\theEDN
		\addtostream{xml}{\space\space<edn>\theEDN</edn>}
	\fi
	\addtostream{xml}{\space</codes>}

	%% Ключевые слова статьи
	\addtostream{xml}{\space<keywords>}
	\addtostream{xml}{\space\space<kwdGroup lang="RUS">}
	\z\z\z\getkeywords\z\z\z{\thekeywordsrus}
	\addtostream{xml}{\space\space</kwdGroup>}
	\addtostream{xml}{\space\space<kwdGroup lang="ENG">}
	\z\z\z\getkeywords\z\z\z{\thekeywordseng}
	\addtostream{xml}{\space\space</kwdGroup>}
	\addtostream{xml}{\space</keywords>}

	%% Литература статьи
	\addtostream{xml}{\space<references>}
	\addtostream{xml}{\space\space<reference></reference>}
	\addtostream{xml}{\space</references>}

	%% Финансирование статьи
	\addtostream{xml}{\space<fundings>}
	\ifx\thefundingrus\@empty\else
		\addtostream{xml}{\space\space<funding lang="RUS">\thefundingrus</funding>}
	\fi
	\ifx\thefundingeng\@empty\else
		\addtostream{xml}{\space\space<funding lang="ENG">\thefundingeng</funding>}
	\fi
	\addtostream{xml}{\space</fundings>}

	%% Даты
	\addtostream{xml}{\space<dates>}
	\addtostream{xml}{\space\space<dateReceived>\datetodots\thedate</dateReceived>}
	\ifdefined\theaccepted
		\addtostream{xml}{\space\space<dateAccepted>\datetodots\theaccepted</dateAccepted>}
	\fi
	\addtostream{xml}{\space</dates>}

	%% Файл
	\addtostream{xml}{\space<files>}
	\addtostream{xml}{\space\space<file></file>}
	\addtostream{xml}{\space\space<furl>https://vestnik.kubsu.ru/article/view/\theOJS</furl>}
	\addtostream{xml}{\space</files>}
	
	\addtostream{xml}{</article>}
	\closeoutputstream{xml}
}

%\newcommand*{\ExtractDay}[1]{\StrBefore[1]{#1}{-}}%
%\newcommand*{\ExtractMonth}[1]{\StrBetween[1,2]{#1}{-}{-}}%
%\newcommand*{\ExtractYear}[1]{\StrBehind[2]{#1}{-}}%
%\newcommand*{\doiSplit}[1]{%
%    \def\doiDay{\ExtractDay{#1}}%
%    \def\doiMonth{\ExtractMonth{#1}}%
%    \def\doiYear{\ExtractYear{#1}}%
%}%

\def\mysplit#1-#2-#3.{\def\doiDay{#1}\def\doiMonth{#2}\def\doiYear{#3}}
\def\doiSplit#1{\expandafter\mysplit#1.}

\newcommand\@write@doi{
	\newoutputstream{doi}
	\openoutputfile{\jobname.doi}{doi}
	
	\addtostream{doi}{<journal_article publication_type="full_text">}

	%% Заголовки статьи
	\addtostream{doi}{\space<titles>}
	\addtostream{doi}{\space\space<title>\thetitleeng</title>}
	\addtostream{doi}{\space\space<original_language_title language="ru">\thetitlerus</original_language_title>}
	\addtostream{doi}{\space</titles>}
	
	%% Цикл авторов статьи
	\addtostream{doi}{\space<contributors>}
	\newcounter{@tmpm}\newcounter{@tmpn}
	
	\whiledo{\value{@tmpm} < \value{author@en@count}}{
		\stepcounter{@tmpm}
		
		\expandafter
		\ifnum\the@tmpm=1
        	\addtostream{doi}{\space\space<organization sequence="first" contributor_role="author">}
        \else
        	\addtostream{doi}{\space\space<organization sequence="additional" contributor_role="author">}
        \fi

		\setcounter{@tmpn}{1}
		\whiledo{\not{\value{@tmpn} > \value{affil@en@count}}}{
			\expandafter
			\ifx\csname @author@en@affil\the@tmpm\endcsname\relax
				\csname @author@en@affil\the@tmpm\endcsname
				\addtostream{doi}{\csname @affil@en@name1\endcsname</organization>}
			\else
				\StrLeft{\csname @author@en@affil\the@tmpm\endcsname}{1}[\@author@en@affil@tmp]
				\ifnum\@author@en@affil@tmp=\the@tmpn
    				\addtostream{doi}{\csname @affil@en@name\the@tmpn\endcsname</organization>}
				\else\fi
			\fi
			\stepcounter{@tmpn}
		}
		
		\expandafter
		\ifnum\the@tmpm=1
        	\addtostream{doi}{\space\space<person_name sequence="first" contributor_role="author">}
        \else
        	\addtostream{doi}{\space\space<person_name sequence="additional" contributor_role="author">}
        \fi
        \addtostream{doi}{\space\space\space<given_name>\@nameuse{@author@en@first\the@tmpm}</given_name>}
        \addtostream{doi}{\space\space\space<surname>\@nameuse{@author@en@last\the@tmpm}</surname>}
        \addtostream{doi}{\space\space</person_name>}
	}
	\addtostream{doi}{\space</contributors>}

	%%% Даты
	\doiSplit{\PRESSDATE}
	\addtostream{doi}{\space<publication_date media_type="print">}
	\addtostream{doi}{\space\space<month>\doiMonth</month>}
	\addtostream{doi}{\space\space<day>\doiDay</day>}
	\addtostream{doi}{\space\space<year>\doiYear</year>}	
	\addtostream{doi}{\space</publication_date>}
	
	%%% Страницы
	\addtostream{doi}{\space<pages>}
	\addtostream{doi}{\space\space<first_page>\FirstPage</first_page>}
	\addtostream{doi}{\space\space<last_page>\lastpage@lastpage</last_page>}
	\addtostream{doi}{\space</pages>}	

	%%% DOI данные
	\addtostream{doi}{\space<doi_data>}
	\addtostream{doi}{\space\space<doi>\doicurrent</doi>}
	\addtostream{doi}{\space\space<resource>https://vestnik.kubsu.ru/article/view/\theOJS</resource>}
	\addtostream{doi}{\space</doi_data>}	
	
	\addtostream{doi}{</journal_article>}
}

%%%%%%% Definitions of new and override some standard commands
\RequirePackage{bm}
\let\oldbm\bm\def\bm#1{\oldbm{\mathrm{#1}}}
\def\const{\mathrm{const}}
\def\Re{\mathop{\mathrm{Re}}\nolimits}
\def\Im{\mathop{\mathrm{Im}}\nolimits}
\def\ci{\mathop{\textrm{ci}}\nolimits}
\def\si{\mathop{\textrm{si}}\nolimits}
\def\grad{\mathop{\mathrm{grad}}\nolimits}
\def\rot{\mathop{\mathrm{rot}}\nolimits}
\def\graddiv{\mathop{\mathrm{graddiv}}\nolimits}
\def\div{\mathop{\mathrm{div}}\nolimits}
\def\sgn{\mathop{\mathrm{sgn}}\nolimits}
\def\sign{\mathop{\mathrm{sign}}\nolimits}
\def\e{\mathrm{e}}
\let\ii\i
%\def\i{{\ensuremath\mathrm{i}}}
\def\ReGoth{%
    \ensuremath{\text{\usefont{OMS}{cmr}{m}{n}\symbol{"3C}}}}
\def\ImGoth{%
    \ensuremath{\text{\usefont{OMS}{cmr}{m}{n}\symbol{"3D}}}}
\def\No{\textnumero}
    
\let\vector\vec
\def\vec#1{\mathbf{#1}}
\newcommand*{\dm}[1]{#1\nobreak\discretionary{}
    {\hbox{$\mathsurround=0pt #1$}}{}
}
\renewcommand{\d}%
   {\@ifnextchar^{\DIfF}{\DIfF^{}}%
}
\def\DIfF^#1{%
   \mathop{\mathrm{\mathstrut d}}%
      \nolimits^{#1}\gobblespace
}
\def\gobblespace{%
   \futurelet\diffarg\opspace%
}
\def\opspace{%
   \let\DiffSpace\!%
   \ifx\diffarg(%
      \let\DiffSpace\relax
   \else
      \ifx\diffarg\[%
         \let\DiffSpace\relax
      \else
         \ifx\diffarg\{%
            \let\DiffSpace\relax
         \fi\fi\fi\DiffSpace%
}

%%%%%%% Required settings for tables
\newcolumntype{Y}{>{%
	\small\centering\arraybackslash}X}
\newcolumntype{C}{>{%
	\small\arraybackslash}c}
\newcolumntype{L}{>{%
	\small\arraybackslash}l}
\newcolumntype{R}{>{%
	\small\arraybackslash}r}
\newcolumntype{P}{>{%
	\small\centering\arraybackslash}p}
\newcolumntype{Q}{>{%
	\small\raggedright\arraybackslash}p}
\def\hlinewd#1{%
	\noalign{\ifnum0=`}\fi\hrule \@height #1 %
	\futurelet\reserved@a\@xhline%
}
\def\hlinew{%
	\noalign{\ifnum0=`}\fi\hrule \@height 1pt %
	\futurelet\reserved@a\@xhline%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatother

\endinput